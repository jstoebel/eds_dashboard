namespace :temp do
  task :add_standard_term => :environment do |task|

    puts "WARNING! You are about to Alter production data! Are you sure? [Y/n]"
    confirm = STDIN.gets.chomp
    fail("task canceled by user") if confirm != "Y"

    # remove all issue_updates and issues
    BannerTerm.transaction do
        BannerTerm.all.each do |term|
          term_str = term.BannerTerm.to_s
          term.standard_term = ["01", "03", "11", "12"].include?(term_str.slice(4,6))

          puts "#{term.BannerTerm}, #{term.standard_term}"

          term.save!
        end
    end # transaction

    puts "standard_term added!"
  end # task
end # scope
