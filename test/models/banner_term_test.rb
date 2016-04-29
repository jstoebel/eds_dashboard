# == Schema Information
#
# Table name: banner_terms
#
#  BannerTerm :integer          not null, primary key
#  PlainTerm  :string(45)       not null
#  StartDate  :datetime         not null
#  EndDate    :datetime         not null
#  AYStart    :integer          not null
#

require 'test_helper'

class BannerTermTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
