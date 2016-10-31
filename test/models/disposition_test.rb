# == Schema Information
#
# Table name: dispositions
#
#  id               :integer          not null, primary key
#  disp_code        :string(255)
#  disp_description :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class DispositionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
