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

require 'test_helper'

class StudentScoreUploadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
