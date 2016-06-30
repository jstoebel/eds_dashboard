class PgpScore< ActiveRecord::Base
    
    self.table_name = 'pgp_scores'
    
    belongs_to :pgp
    
    scope :sorted, lambda {order(:score_date => :desc)}
    
    validates_numericality_of :goal_score, greater_than: 0
    validates_numericality_of :goal_score, less_than: 5
    validates :score_reason,
        presence: {message: "Please enter a score reason."}
end