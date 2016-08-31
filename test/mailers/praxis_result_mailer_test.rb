require 'test_helper'

class PraxisResultMailerTest < ActionMailer::TestCase

  describe "email student" do

      before do
        @failing_test = FactoryGirl.create :praxis_result # its ok that its not actually failing
      end

      test "emails student" do

      end

      test "ccs app admin" do
        
      end

  end

end
