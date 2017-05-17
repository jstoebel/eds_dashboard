# == Schema Information
#
# Table name: student_score_uploads
#
#  id         :integer          not null, primary key
#  source     :string(255)
#  success    :boolean
#  message    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StudentScoreUpload < ActiveRecord::Base

  has_many :student_scores, dependent: :destroy
  has_many :student_score_temps, dependent: :destroy

  before_save :validate_source

  validates_presence_of :message,
    :if => Proc.new{|s| !s.success.nil?}

  private
  def validate_source
    if !StudentScore.format_types.include? self.source.to_sym
      self.errors.add(:source, "Invalid upload source")
    end
  end # validate_source

end
