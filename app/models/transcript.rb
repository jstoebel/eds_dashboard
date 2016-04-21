class Transcript < ActiveRecord::Base
	self.table_name = 'transcript'
	belongs_to :student, {:foreign_key => 'Student_Bnum'}
    belongs_to :banner_term, :foreign_key => "term_take"

	scope :in_term, ->(term_object) { where(term_taken: term_object.BannerTerm)}
end
