# == Schema Information
#
# Table name: student_scores
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  item_level_id         :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

=begin
=end

class StudentScore < ActiveRecord::Base
    
    belongs_to :student
    belongs_to :assessment_version
    belongs_to :item_level
    belongs_to :assessment_item
    
    validates_presence_of :student_id, :assessment_version_id, :assessment_item_id, :item_level_id
    
    def self.to_csv(options = {})
        CSV.generate(options) do |csv|
            csv << column_names
            all.each do |score|
                csv << score.attributes.values_at(*column_names)
            end
        end
    end
        
    def self.find_ver(file)
      CSV.foreach(file.path, headers: true) do |row|
        return row["assessment_version_id"]
      end
    end
    
    def self.create_pending(parameters)
      return PendingStudentScores.create(parameters.permit(:first_name, :last_name, :assessment_version_id, :assessment_item_id, :item_level_id))
    end
    
    def self.import_create(file)
        version = (self.find_ver(file))
        created = {:ver => version, :scores => [], :pending => []}
        CSV.foreach(file.path, headers: true) do |row|
            ##For each value under an assessment_item header in a single row, create a new score
            items = []
            first_item = row.index("assessment_version_id") + 1
            (first_item..row.length).each do |item|    #push each item that has a score. 
            #item is the index number
                if row[item] != nil
                  items.push(item)
                end
            end
            items.each do |score|
              attribute_array = []
              ver_id = row["assessment_version_id"]
              item_id = row.headers[score].to_s.split(" ").slice(1)
              lev_id = AssessmentItem.find(item_id).item_levels.find_by(ord: row[row.headers[score]]).id
              attribute_array.push(["assessment_version_id", ver_id], ["assessment_item_id", item_id], ["item_level_id", lev_id])

              #stu_id = Student.find_by(Bnum: row["Bnum"]).id
              #if name matches exactly and only once
              if Student.where(FirstName: row["FirstName"], LastName: row["LastName"]).length == 1
                 stu_id = Student.find_by(FirstName: row["FirstName"], LastName: row["LastName"]).id
              else
                attribute_array.push(["first_name", row["FirstName"]], ["last_name", row["LastName"]])
                parameters = ActionController::Parameters.new(attribute_array.to_h)
                created[:pending].push(create_pending(parameters))
                #created[:pending].push(PendingStudentScores.create(parameters.permit(:first_name, :last_name, :assessment_version_id, :assessment_item_id, :item_level_id)))
                #ver_and_matches.push([ attribute_array.to_h, self.find_stu(row["FirstName"], row["LastName"]) ] )
                next    #goes to next iteration
              end
  
              attribute_array.push(["student_id", stu_id])
              ## Whitelisting example found at https://github.com/rails/strong_parameters
              parameters = ActionController::Parameters.new(attribute_array.to_h)
              created[:scores].push(StudentScore.create(parameters.permit(:student_id, :assessment_version_id, :assessment_item_id, :item_level_id)))
            end
        end
        return created
    end
end
