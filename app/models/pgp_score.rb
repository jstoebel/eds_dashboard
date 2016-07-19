class PgpScore< ActiveRecord::Base
    
    self.table_name = 'pgp_scores'
    belongs_to :pgp 
    
    scope :sorted, lambda {order(:created_at)}
    
    validates_numericality_of :goal_score, greater_than: 0
    validates_numericality_of :goal_score, less_than: 5
    validates :score_reason,
        presence: {message: "Please enter a score reason."}

        
    def student
        self.pgp.student
    end
    
    def latest_score
        self.pgp_scores.order(:created_at).first
    end

end