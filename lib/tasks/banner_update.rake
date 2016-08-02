require 'dbi'
task :banner_update, [:start_term, :end_term, :send_emails] => :environment do |t, args|
  # updates banner pulling all students who were enrolled in EDS 150 in any of
  # the terms between start_term and end_term

  # specific steps:
    # for each term
      # for each student
        # insert new students (students, advisor_assignments)
        # update existing students
      # upsert transcript
      # update log

    DBI.connect("DBI:OCI8:bannerdbrh.berea.edu:1521/rhprod", SECRET["BANNER_UN"], SECRET["BANNER_PW"]) do |dbh|
        sql = "SELECT * FROM saturn.szvedsd WHERE SZVEDSD_FILTER_TERM=201412"

        visited_students = []
        existing_students = Student.all

        dbh.select_all(sql) do |row|

          puts row['SAVEDSD_INSTRUCTOR']

          bnum = row['SZVEDSD_ID']
          row_service = ProcessStudent.new row

          #STUDENT LEVEL
          if !visited_students.include? bnum
            # student level info
            visited_students << bnum

            begin
              row_service.upsert
            rescue ActiveRecord::RecordInvalid => exception
              p "caught exception!"
              p exception.to_s
              log_error exception
            end

            # update advisor assignments
            begin
              row_service.update_advisor_assignments
            rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => exception
              log_error exception

            end

          end

          # ROW BY ROW (TRANSCRIPT)
          row_service.upsert_course

        end
    end
end



def log_error(exception)
    # logs exception tagged with the task name and timestamp
    # exception includes a class, message and backtrace

    # more info: http://blog.bigbinary.com/2014/03/03/logger-formatting-in-rails.html
    # and http://guides.rubyonrails.org/debugging_rails_applications.html#tagged-logging
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.tagged("BANNER UPDATE", task.timestamp){
      Rails.logger.info exception.class.to_s
      Rails.logger.info exception.to_s
      Rails.logger.info exception.backtrace.join("\n")
     }
end
