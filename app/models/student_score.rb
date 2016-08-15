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
    
    def self.import_create(file)
        ver_and_matches = []
        ver_and_matches.push(find_ver(file))
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
              if Student.find_by(FirstName: row["FirstName"], LastName: row["LastName"]) == nil
                #find_stu returns list of 
                ver_and_matches.push([ attribute_array, find_stu(row["FirstName"], row["LastName"]) ] )
                next    #goes to next iteration
              else
                 stu_id = Student.find_by(FirstName: row["FirstName"], LastName: row["LastName"]).id
              end
  
              attribute_array.push(["student_id", stu_id])
              ## Whitelisting example found at https://github.com/rails/strong_parameters
              parameters = ActionController::Parameters.new(attribute_array.to_h)
              StudentScore.create(parameters.permit(:student_id, :assessment_version_id, :assessment_item_id, :item_level_id))
            end
        end
        return ver_and_matches
    end
    
    def find_ver(file)
      CSV.foreach(file.path, headers: true) do |row|
        return row["assessment_version_id"]
      end
    end
        
    
    def find_stu(first, last)
        #method takes first and last name, returns list of possible matching students
        pos_matches = []
        pos_matches.push(Student.where({ FirstName: %first or LastName: %last) #Student.find_by(FirstName)
    #   Student.find_by(LastName)
    #  return 
    
    ##TODO Bnum not provided but may be in future
      #stu_id found through first name last name match
      #else not perfect match
      #call find_stu, compare to preferred, last-names, etc
      #if only one match, give student id
      #else, display screen picking student, assign that stu_id
    end
end
