# == Schema Information
#
# Table name: programs
#
#  id           :integer          not null, primary key
#  ProgCode     :string(10)       not null
#  EPSBProgName :string(100)
#  EDSProgName  :string(45)
#  Current      :boolean
#  license_code :string(255)
#

require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
