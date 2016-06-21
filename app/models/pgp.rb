class Pgp < ActiveRecord::Base
    has_many :pgp_scores
    belongs_to :student
    
    validates :goal_name,
        presence: {message:"Please enter a goal."}
    validates :description,
        presence: {message:"Please enter a description."}
    validates :plan,
        presence: {message:"Please enter a plan."}
end
