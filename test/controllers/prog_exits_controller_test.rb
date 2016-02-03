require 'test_helper'

class ProgExitsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "staff"]
  bad_roles = ["advisor", "student labor"]

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
      get :need_exit, {:prog_exit_id => "exit"}

      assert_response :success
      #TODO 
      #test @needs_exit once this is implemented

    end
  end

  test "should get new" do

    allowed_roles.each do |s|
      load_session(s)

      stu = Student.first
      prog = stu.programs.first
      expected_exit = ProgExit.new
      get :new
      
      assert_response :success
      assert_equal expected_exit, assigns(:exit)
      test_new_setup
    end
  end

  test "should post create" do
    term = BannerTerm.first
    start_date = (term.StartDate.to_date) + 1

    travel_to start_date do
      allowed_roles.each do |r|

        load_session(r)

        adm = AdmTep.first
        exit = ProgExit.where(
          :Student_Bnum => adm.Student_Bnum,
          :Program_ProgCode => adm.Program_ProgCode
          ).first

        if exit
          exit.destroy  #if there was an exit to this admission, destroy it so we can create a new one.
        end

        stu = adm.student
        prog = adm.program

        post :create, {:prog_exit => {
            :Student_Bnum => adm.Student_Bnum,
            :Program_ProgCode => prog.id,
            :ExitCode_ExitCode => "1826",   #dropped out
            :ExitDate => start_date.strftime("%m/%d/%Y"),
            :GPA => 2.5,
            :GPA_last60 => 3.0 
          }}

        assert_equal flash[:notice], "Successfully exited #{ApplicationController.helpers.name_details(assigns(:exit).student)} from #{assigns(:exit).program.EDSProgName}. Reason: #{assigns(:exit).exit_code.ExitDiscrip}."
        assert_redirected_to prog_exits_path

      end
    end
  end

  test "should not post create bad record" do
    term = BannerTerm.first
    start_date = (term.StartDate.to_date) + 1

    travel_to start_date do
      allowed_roles.each do |r|

        load_session(r)

        adm = AdmTep.first
        exit = ProgExit.where(
          :Student_Bnum => adm.Student_Bnum,
          :Program_ProgCode => adm.Program_ProgCode
          ).first

        if exit
          exit.destroy  #if there was an exit to this admission, destroy it so we can create a new one.
        end

        stu = adm.student
        prog = adm.program

        post :create, {:prog_exit => {
            :Student_Bnum => adm.Student_Bnum,
            :Program_ProgCode => "999",   #bad program code, will trip an error
            :ExitCode_ExitCode => "1826",   #dropped out
            :ExitDate => start_date.strftime("%m/%d/%Y"),
            :GPA => 2.5,
            :GPA_last60 => 3.0 
          }}

        assert_response :success
        test_new_setup
        assert_template 'new'

      end
    end
  end

  test "should get new_specific" do

    allowed_roles.each do |r|
      load_session(r)

      stu = Student.first
      adm = stu.adm_tep.first
      prog = adm.program
      expected_exit = ProgExit.new({
          :Student_Bnum => stu.Bnum,
          :Program_ProgCode => prog.id
        })

      get :new_specific, {:prog_exit_id => stu.AltID, :program_id => prog.id}

      assert_response :success
      assert_equal expected_exit, assigns(:exit)
    end
  end

  test "should get edit" do
    allowed_roles.each do |r|
      load_session(r)

      expected_exit = ProgExit.first
      get :edit, {:id => expected_exit.id}
      assert_response :success
      assert_equal expected_exit, assigns(:exit)
    end    
  end

  test "should post update" do
    allowed_roles.each do |r|
      load_session(r)

      expected_exit = ProgExit.first

      
      expected_exit.student.update(
        :EnrollmentStatus => "Graduation"
      ) #graduate this student!

      expected_exit.Details = "more datails!"
      update_params = {
        :Details => expected_exit.Details
      }
      post :update, {:id => expected_exit.id, :prog_exit => update_params}
      assert_equal expected_exit, assigns(:exit)
      assert_equal flash[:notice], "Edited exit record for #{ApplicationController.helpers.name_details(assigns(:exit).student)}"
      assert_redirected_to prog_exits_path

    end  
  end

  test "should get choose" do
    allowed_roles.each do |r|
      load_session(r)

      exit = ProgExit.first

      expected_term = exit.banner_term
      get :choose, {:prog_exit_id => "pick", :banner_term => {:menu_terms => expected_term.id}}
      assert_redirected_to (banner_term_prog_exits_path(assigns(:term)))

    end      
  end

  test "should get get_programs" do
    allowed_roles.each do |r|
      load_session(r)
      expected_student = Student.first

      #build the expected response
      open_admissions = AdmTep.open(expected_student.Bnum)
      open_programs = open_admissions.map { |i| i.program }

      expected_json = {}

      open_programs.each do |p|   #build a hash with each program mapped to its id
        expected_json.merge!({ p.ProgCode => p.EDSProgName })
      end

      get :get_programs, {:alt_id => expected_student.AltID}
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
      get :need_exit, {:prog_exit_id => "who cares"}
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

  test "should not post create bad role" do
    (role_names - allowed_roles).each do |r|
      
      load_session(r)
      post :create, {:prog_exit => {
            :Student_Bnum => "bnum",
            :Program_ProgCode => "id",
            :ExitCode_ExitCode => "1826",   #dropped out
            :ExitDate => "date!",
            :GPA => 2.5,
            :GPA_last60 => 3.0 
          }}
      assert_redirected_to "/access_denied"

    end    
  end

  test "should not get new_specific bad role" do
    (role_names - allowed_roles).each do |r|
      
      load_session(r)
      get :new_specific, {:prog_exit_id => "altid", :program_id => "progid"}
      assert_redirected_to "/access_denied"

    end     
  end

  test "should not get edit bad role" do
    (role_names - allowed_roles).each do |r|
      
      load_session(r)
      get :edit, {:id => "id"}
      assert_redirected_to "/access_denied"

    end    
  end

  test "should not post update bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      update_params = {
        :Details => "Details"
      }
      post :update, {:id => "id", :prog_exit => update_params}
      assert_redirected_to "/access_denied"

    end    
  end

  test "should not get choose bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :choose, {:prog_exit_id => "pick", :banner_term => {:menu_terms => "expected_term.id"}}
      assert_redirected_to "/access_denied"
    end    
  end

  test "should not get get_programs bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :get_programs, {:alt_id => "expected_student.AltID"}
      assert_redirected_to "/access_denied"
    end    
  end

  private
  def test_new_setup
    expected_students = Student.all.where("ProgStatus in (?, ?)", "Candidate", "Completer").by_last    
    assert_equal expected_students, assigns(:students)
    assert_equal [], assigns(:programs)
    assert_equal ExitCode.all, assigns(:exit_reasons)
  end
end
