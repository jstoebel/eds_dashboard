require 'dbi'
task :banner_update, [:start_term, :end_term] => :environment do |task, args|
  # updates banner pulling all students who were enrolled in EDS 150 in any of
  # the terms between start_term and end_term
  # call this task like this rake banner_update[:start_term, :end_term] RAILS_ENV=production

  # specific steps:
    # for each term
      # for each student
        # insert new students (students, advisor_assignments)
        # update existing students
      # upsert transcript
      # update log
    start_term = args[:start_term]
    end_term = args[:end_term]

    if start_term.nil? || end_term.nil?
      fail "a start and end term must be supplied."
    end

    error_count = 0
    terms = BannerTerm.where({:BannerTerm => start_term..end_term})

    terms.each do |t|

      puts "Query for #{t.BannerTerm}"

      conn = BannerConnection.new t.BannerTerm
      rows = conn.get_results

      visited_students = []
      existing_students = Student.all

      rows.each do |row|

        bnum = row["SZVEDSD_ID"]

        row_service = ProcessStudent.new row

        #STUDENT LEVEL
        if !visited_students.include? bnum
          # student level info
          visited_students << bnum

          begin
            row_service.upsert_student
          rescue ActiveRecord::RecordInvalid => exception
            log_error exception, "Error trying to upsert student #{row_service.stu.name_readable}: #{exception.to_s}", task
            error_count += 1
          end

          # update advisor assignments
          begin
            row_service.update_advisor_assignments
          rescue ActiveRecord::StatementInvalid => exception
            log_error exception, "Error trying to update advisor assginements for #{row_service.stu.name_readable}: #{exception.to_s}", task
            error_count += 1
          end

        end

        # ROW BY ROW (TRANSCRIPT)
        begin
          row_service.upsert_course
        rescue ActiveRecord::RecordInvalid => exception
          log_error exception, "Error trying to upsert course for #{row_service.stu.name_readable}: #{exception.to_s}", task
          error_count += 1
        end

      end #row
    end # main loop

    begin
      BannerUpdate.create!({
        start_term: start_term,
        end_term: end_term
        })
    rescue ActiveRecord::RecordInvalid => exception
      log_error exception, "Error trying to create new BannerUpdate", t
      error_count += 1
    end

    BannerUpdateMailer.update_done(task.timestamp, error_count).deliver_now

end

def log_error(exception, context_message, task)
    # logs exception tagged with the task name and timestamp
    # exception includes a class, message and backtrace
    # task, the rake task where the exception was thrown

    # more info: http://blog.bigbinary.com/2014/03/03/logger-formatting-in-rails.html
    # and http://guides.rubyonrails.org/debugging_rails_applications.html#tagged-logging
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.tagged("BANNER UPDATE", task.timestamp){
      Rails.logger.info exception.class.to_s
      Rails.logger.info exception.to_s
      Rails.logger.info exception.backtrace.join("\n")
      Rails.logger.info context_message
     }
end
