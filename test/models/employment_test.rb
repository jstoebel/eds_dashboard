# == Schema Information
#
# Table name: employment
#
#  id         :integer          not null, primary key
#  student_id :integer
#  category   :integer
#  employer   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class EmploymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
