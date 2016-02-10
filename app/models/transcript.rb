class Transcript < ActiveRecord::Base
	self.table_name = 'transcript'
    self.primary_keys :crn, :Student_Bnum
	belongs_to :student, {:foreign_key => 'Student_Bnum'}

	scope :in_term, ->(term_object) { where(term_taken: term_object.BannerTerm)}
end
