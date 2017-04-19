# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text(65535)
#

require 'test_helper'
class ProgExitsControllerTest < ActionController::TestCase

  role_names = Role.all.pluck :RoleName
  allowed_roles = ["admin", "staff"]

  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      get :index
      assert_response :success
      assert_equal assigns(:exits), ProgExit.all.by_term(assigns(:term))

      #TODO
      #test @needs_exit once this is implemented

    end
  end

  test "should get need_exit" do
    allowed_roles.each do |r|
      load_session(r)
      get :need_exit, params: {:prog_exit_id => "exit"}

      assert_response :success
      #TODO
      #test @needs_exit once this is implemented

    end
  end

  test "should get new" do

    allowed_roles.each do |s|
      load_session(s)

      # stu = FactoryGirl.create :student
      # program = FactoryGirl.create :program, {:student_id => stu.id}
      expected_exit = ProgExit.new
      get :new

      assert_response :success
      assert assigns(:exit).new_record?
      test_new_setup
    end
  end

  describe "create" do
    allowed_roles.each do |r|
      test "as #{r} should post" do
        load_session(r)
        prog_exit = FactoryGirl.build :successful_prog_exit
        stu = prog_exit.student
        stu.EnrollmentStatus = "Graduation"
        stu.save!

        post :create, params: {:student_id => stu.id, :prog_exit => prog_exit.attributes}
        assert assigns(:exit).valid?, assigns(:exit).errors.full_messages
        assert_redirected_to prog_exits_path
        assert_equal flash[:notice], "Successfully exited #{ApplicationController.helpers.name_details(assigns(:exit).student)} from #{assigns(:exit).program.EDSProgName}. Reason: #{assigns(:exit).exit_code.ExitDiscrip}."
      end
    end

    ( role_names - allowed_roles).each do |r|
      test "as #{r} should not post" do
        load_session(r)
        post :create, params: {:prog_exit => {
          :student_id => "bnum",
          :Program_ProgCode => "id",
          :ExitCode_ExitCode => "1826",   #dropped out
          :ExitDate => "date!",
          :GPA => 2.5,
          :GPA_last60 => 3.0,
          :AltID => "who cares"
          }}
          assert_redirected_to "/access_denied"
      end
    end
  end

  test "should get new_specific" do

    allowed_roles.each do |r|
      load_session(r)

      stu = FactoryGirl.create :admitted_student
      adm = stu.adm_tep.first
      prog = adm.program
      expected_exit = ProgExit.new({
          :student_id => stu.id,
          :Program_ProgCode => prog.id
        })

      get :new_specific, params: {:prog_exit_id => stu.AltID, :program_id => prog.id}

      assert_response :success
      assert assigns(:exit).new_record?
      assert_equal assigns(:exit).student_id, stu.id
      assert_equal assigns(:exit).Program_ProgCode, prog.id
    end
  end

  describe "edit" do

    allowed_roles.each do |r|
      test "as #{r} should get" do
        load_session(r)

        expected_exit = FactoryGirl.create :successful_prog_exit
        get :edit, params: {:id => expected_exit.AltID}
        assert_response :success
        assert_equal expected_exit, assigns(:exit)
      end # test
    end # roles loop

    (role_names - allowed_roles).each do |r|
      test "as #{r} should not get" do

        load_session(r)
        get :edit, params: {:id => "id"}
        assert_redirected_to "/access_denied"
      end
    end # roles loop

  end

  describe "update" do
    allowed_roles.each do |r|
      test "as #{r} should post" do
        load_session(r)
        prog_exit = FactoryGirl.create :successful_prog_exit
        stu = prog_exit.student
        stu.EnrollmentStatus = "Graduation"
        stu.save!

        new_attrs = prog_exit.attributes.merge({"RecommendDate" => prog_exit.RecommendDate + 1})

        post :update, params: {:id => prog_exit.id, :prog_exit => new_attrs}
        assert assigns(:exit).valid?, assigns(:exit).errors.full_messages
        assert_equal new_attrs["RecommendDate"], assigns(:exit).attributes["RecommendDate"]
        assert_equal flash[:notice], "Edited exit record for #{ApplicationController.helpers.name_details(assigns(:exit).student)}"
        assert_redirected_to banner_term_prog_exits_path(prog_exit.banner_term.id)
      end
    end

    (role_names - allowed_roles).each do |r|
      test "as #{r} should not post" do
        load_session(r)
        update_params = {
          :Details => "Details"
        }
        post :update, params: {:id => "id", :prog_exit => update_params}
        assert_redirected_to "/access_denied"
      end
    end

  end

  describe "choose" do
    allowed_roles.each do |r|
      test "as #{r} should get" do
        load_session(r)

        prog_exit = FactoryGirl.create :successful_prog_exit

        expected_term = prog_exit.banner_term
        get :choose, params: {:prog_exit_id => "pick", :banner_term => {:menu_terms => expected_term.id}}
        assert_redirected_to (banner_term_prog_exits_path(assigns(:term)))

      end
    end

    (role_names - allowed_roles).each do |r|
      test "as #{r} should not" do
        load_session(r)
        get :choose, params: {:prog_exit_id => "pick", :banner_term => {:menu_terms => "expected_term.id"}}
        assert_redirected_to "/access_denied"
      end
    end
  end


  test "should get get_programs" do
    allowed_roles.each do |r|
      load_session(r)
      expected_student = FactoryGirl.create :student

      #build the expected response
      open_admissions = AdmTep.open(expected_student.Bnum)
      open_programs = open_admissions.map { |i| i.program }

      expected_json = {}

      open_programs.each do |p|   #build a hash with each program mapped to its id
        expected_json.merge!({ p.ProgCode => p.EDSProgName })
      end

      get :get_programs, params: {:id => expected_student.id}
      assert_response :success

      json_response = JSON.parse(@response.body)
      assert_equal expected_json, json_response

    end
  end

  #TESTS FOR UNAUTHORIZED USERS
  test "should not get index bad role" do
    (role_names - allowed_roles).each do |r|

      load_session(r)
      get :index
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get need_exit bad role" do
    (role_names - allowed_roles).each do |r|

      load_session(r)
      get :need_exit, params: {:prog_exit_id => "who cares"}
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get new bad role" do
    (role_names - allowed_roles).each do |r|

      load_session(r)
      get :new
      assert_redirected_to "/access_denied"

    end
  end



  test "should not get new_specific bad role" do
    (role_names - allowed_roles).each do |r|

      load_session(r)
      get :new_specific, params: {:prog_exit_id => "altid", :program_id => "progid"}
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get get_programs bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :get_programs, params: {:alt_id => "expected_student.AltID"}
      assert_redirected_to "/access_denied"
    end
  end

  private
  def test_new_setup
    expected_students = Student.all.select {|s| s.prog_status == "Candidate"}
    assert_equal expected_students, assigns(:students)
    assert_equal [], assigns(:programs)
    assert_equal ExitCode.all, assigns(:exit_reasons)
  end
end
