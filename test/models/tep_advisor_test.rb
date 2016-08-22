# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(45)       not null
#  user_id     :integer
#  first_name  :string(255)      not null
#  last_name   :string(255)      not null
#  email       :string(255)
#

require 'test_helper'

class TepAdvisorTest < ActiveSupport::TestCase

  describe "get_email" do

    before do
      @adv = FactoryGirl.create :tep_advisor
    end

    it "returns tep_advisor_email" do
      assert_equal @adv.get_email, @adv.email
    end

    it "returns user email" do
      user = @adv.user
      @adv.email = nil
      assert @adv.save
      assert_equal user.Email, @adv.get_email
    end
  end


end
