# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  concentration1   :string(255)
#  CurrentMajor2    :string(45)
#  concentration2   :string(255)
#  CellPhone        :string(45)
#  CurrentMinors    :string(255)
#  Email            :string(100)
#  CPO              :string(45)
#  withdraws        :text(65535)
#  term_graduated   :integer
#  gender           :string(255)
#  race             :string(255)
#  hispanic         :boolean
#  term_expl_major  :integer
#  term_major       :integer
#

require 'test_helper'
class StudentsControllerTest < ActionController::TestCase
  self.pre_loaded_fixtures = false
  allowed_roles = ["admin", "staff", "advisor"]

  before do
    @controller = StudentsController.new
  end


  describe "index" do

    allowed_roles.each do |r|

      describe "as #{r}" do

        before do
          load_session(r)

          @user = User.find_by :UserName => session[:user]
          @my_student = FactoryGirl.create :student
          if @user.tep_advisor.blank?
            @advisor = FactoryGirl.create :tep_advisor, {:user_id => @user.id}
          else
            @advisor = @user.tep_advisor
          end

          AdvisorAssignment.create({:student_id => @my_student.id,
              :tep_advisor_id => @advisor.id
            })

        end

        test "no params" do
          get :index
          abil = Ability.new(@user)

          assert_response :success
          assert Student.by_last.active_student.current.select{|s| abil.can? :read, s}, assigns(:students)
        end

        describe "basic search" do

          fields = [:FirstName, :PreferredFirst, :LastName]

          fields.each do |f|
            test f do
              get :index, {:search => @my_student.send(f)}
              assert :success
              assert_equal [@my_student], assigns(:students).to_a
            end
          end

        end

        test "with prev last name" do
          stu_last = @my_student.last_names.first.last_name
          get :index, {:search => stu_last}
          assert :success
          assert_equal [@my_student], assigns(:students).to_a
        end

        test "with multiple words" do
          search_str = "#{@my_student.FirstName} spam"
          get :index, {:search => search_str}
          assert :success
          assert_equal [@my_student], assigns(:students).to_a
        end

        test "with all" do
          abil = Ability.new(@user)

          get :index, {:all => :true}

          assert :success
          assert_equal Student.all.by_last.select{|s| abil.can? :read, s}, assigns(:students)
        end

      end # as r

    end # roles loop

  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      stu = Student.first
      get :show, :id => stu.AltID
      assert_response :success
      assert_equal stu, assigns(:student)

    end
  end

  test "should not get show bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :show, {:id => Student.first.id}
      assert_redirected_to "/access_denied"
    end
  end

end
