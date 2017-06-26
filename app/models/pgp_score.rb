# == Schema Information
#
# Table name: pgp_scores
#
#  id           :integer          not null, primary key
#  pgp_id       :integer
#  goal_score   :integer
#  score_reason :text(65535)
#  created_at   :datetime
#  updated_at   :datetime
#

# a single score on a PGP item
class PgpScore< ApplicationRecord
    
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
        # the latest score recieved on this item
        self.pgp_scores.order(:created_at).first
    end

end
