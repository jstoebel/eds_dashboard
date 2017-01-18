require 'test_helper'
class HelpsControllerTest < ActionController::TestCase

  roles = Role.all.pluck :RoleName

  describe "help" do

    roles.each do |r|

      test "as #{r}" do
        load_session(r)
        get :home
        assert_response :success
      end
    end

  end

end
