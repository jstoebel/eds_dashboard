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
        CSV.foreach(file.path, headers: true) do |row|
            ##For each value under an assessment_item header in a single row, create a new score
            items = []
            (4..row.length).each do |item|    #push each item that has a score
            #item is the index number
                if row[item] != nil
                  items.push(item)
                end
            end
            items.each do |score|
              attribute_array = []
              stu_id = Student.find_by(Bnum: row["Bnum"]).id
              ver_id = row["assessment_version_id"]
              item_id = row.headers[score].to_s.split(" ").slice(1)
              lev_id = AssessmentItem.find(item_id).item_levels.find_by(ord: row[row.headers[score]]).id
            
              attribute_array.push(["student_id", stu_id], ["assessment_version_id", ver_id], ["assessment_item_id", item_id], ["item_level_id", lev_id])
              puts attribute_array.inspect
              puts attribute_array.to_h.inspect
              #TODO will have to make sure only accessible attributes
              StudentScore.create! attribute_array.to_h
            end
        end
    end
end
