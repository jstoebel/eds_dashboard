# == Schema Information
#
# Table name: student_score_temps
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  item_level_id           :integer
#  scored_at               :datetime
#  full_name               :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  student_score_upload_id :integer
#

require 'test_helper'

class StudentScoreTempTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
