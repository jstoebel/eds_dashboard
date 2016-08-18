class PendingStudentScore < ActiveRecord::Base
    
    belongs_to :assessment_version
    belongs_to :item_level
    belongs_to :assessment_item
    
    validates_presence_of :first_name, :last_name, :assessment_version_id, :assessment_item_id, :item_level_id
    
    scope :sorted, lambda {order(:assessment_version_id => :asc, :created_at => :asc)}
    
    def find_stu
      #method takes first and last name, returns list of possible matching students
      pos_matches = []
      Student.where( FirstName: self.first_name).to_a.each{|stu| pos_matches.push(stu)}
      (Student.where(LastName: self.last_name).to_a - pos_matches).each{|stu| pos_matches.push(stu)}
      return pos_matches
    end
    
    #need transaction 
end