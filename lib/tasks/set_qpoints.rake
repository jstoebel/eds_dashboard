task :set_qpoints => :environment do
  courses = Transcript.all

  Transcript.transaction do
    courses.each do |c|

      if c.grade_pt.present? && c.credits_earned.present?
          #sets quality_points for a record
          c.quality_points = c.grade_pt * c.credits_earned
          c.save!
          puts "."
      end
    end

  end # transaction
end
