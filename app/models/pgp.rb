class Pgp < ActiveRecord::Base
    self.table_name = 'pgps'
    
    belongs_to :student
    has_many :pgp_scores, dependent: :destroy
    
    
    scope :sorted, lambda {order(:created_at => :desc)}
    
    validates :student_id,
        presence: {message:"There must be an active student associated."}
    validates :goal_name,
        presence: {message:"Please enter a goal."}
    validates :description,
        presence: {message:"Please enter a description."}
    validates :plan,
        presence: {message:"Please enter a plan."}

    def latest_score
        self.pgp_scores.order(:created_at).first
    end
end
