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
                        if: proc {|s| !s.success.nil?}

  private

  ##
  # validate that the input source is valid
  # TODO: refactor as validates :source
  def validate_source
    unless StudentScore.format_types.include? source.to_sym
      errors.add(:source, 'Invalid upload source')
    end
  end # validate_source
end
