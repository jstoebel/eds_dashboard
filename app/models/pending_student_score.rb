class PendingStudentScore < ActiveRecord::Base
    
    
    belongs_to :assessment_version
    belongs_to :item_level
    belongs_to :assessment_item
    
    validates_presence_of :first_name, :last_name, :assessment_version_id, :assessment_item_id, :item_level_id
    
    scope :sorted, lambda {order(:assessment_version_id => :asc, :created_at => :asc)}
    
    def find_stu
        ##Change to scope 
      #method takes first and last name, returns list of possible matching students
      pos_matches = []
      Student.where( FirstName: self.first_name).to_a.each{|stu| pos_matches.push(stu)}
      (Student.where(LastName: self.last_name).to_a - pos_matches).each{|stu| pos_matches.push(stu)}
      return pos_matches
    end
    
    
    def self.to_scores(pending)
        #pending should hold student_id 
      begin
        PendingStudentScore.transaction do
          StudentScore.create
          self.destroy
          return true
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => msg    
      #TODO, test that both outcomes produce expected
        return false
      end
    end
    
    #need transaction 
end