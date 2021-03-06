namespace :temp do
  task :change_st_files => :environment do |task|

    puts "This will create associative records for student files"
    puts "WARNING! You are about to alter production data! Are you sure? [Y/n]"
    confirm = STDIN.gets.chomp
    fail("task canceled by user") if confirm != "Y"

    # remove all issue_updates and issues
    AdmSt.transaction do
        AdmSt.all.each do |app|
            # create an associative file for each student file related to an
            # adm_tep

            if app.student_file_id.present?
                StFile.create!({
                    :student_file_id => app.student_file_id,
                    :adm_st_id => app.id
                })
            end

            puts "created record for #{app.student.name_readable}: #{app.banner_term.id}."
        end
    end # transaction

    puts "done!"
  end # task
end # scope
