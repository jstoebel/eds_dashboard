require 'test_helper'
class TranscriptsControllerTest < ActionController::TestCase
  roles = Role.all.pluck :RoleName

  describe "index" do
    roles.each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
          user = User.find_by :UserName => session[:user]
          advisor = FactoryGirl.create :tep_advisor, :user => user
          assignment = FactoryGirl.create :advisor_assignment, :tep_advisor => advisor

          this_term = FactoryGirl.create :banner_term, :StartDate => 5.days.ago,
            :EndDate => 5.days.from_now
          @course = FactoryGirl.create :transcript, :student => assignment.student,
            :banner_term => this_term
          get :index, params: {:student_id => @course.student.id}

          @expected = @course.attributes
        end

        test "successful" do
          # puts response.body
          assert :success
          assert_equal [@expected], JSON.parse(response.body)
        end

      end
    end
  end # outer describe

end
