class Pgp < ActiveRecord::Base
    self.table_name = 'pgps'
    
    belongs_to :student
    
    scope :sorted, lambda {order(:created_at => :desc)}
    
    validates :student_id,
        presence: {message:"There must be an active student associated."}
    validates :goal_name,
        presence: {message:"Please enter a goal."}
    validates :description,
        presence: {message:"Please enter a description."}
    validates :plan,
        presence: {message:"Please enter a plan."}
    validates_numericality_of :goal_score, greater_than: 0
    validates_numericality_of :goal_score, less_than: 5
    validates :score_reason,
        presence: {message: "Please enter a score reason."}
end
