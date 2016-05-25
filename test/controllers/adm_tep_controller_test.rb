
require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess
require 'test_teardown'
require 'factory_girl'
class AdmTepControllerTest < ActionController::TestCase
  include TestTeardown
  allowed_roles = ["admin", "staff"]    #only these roles are allowed access

  test "should get new" do

    term = BannerTerm.first
    start_date = (term.StartDate.to_date) + 1

    travel_to start_date do
      allowed_roles.each do |r|
        load_session(r)
        get :new
        assert_response :success
      end
    end
  end

  test "should post create" do
    term = BannerTerm.first
    start_date = (term.StartDate.to_date) + 1
    stu = Student.first

    pop_transcript(stu, 12, 3.0, term)

    prog = Program.first
    travel_to start_date do
      allowed_roles.each do |r|
        AdmTep.delete_all   #clear entire table or else the record won't save on the second iteration
        load_session(r)
        post :create, {:adm_tep => {
            :student_id => stu.id,
            :Program_ProgCode => prog.id,
            :BannerTerm_BannerTerm =>  BannerTerm.current_term.id
          }
        }

        assert_redirected_to adm_tep_index_path
        assert_equal flash[:notice], "New application added: #{ApplicationController.helpers.name_details(stu)}-#{prog.EDSProgName}"
      end
    end
  end

  test "should not post create bad app" do
    #create a conflict with the existing app

    load_session("admin")
    existing_app = AdmTep.first
    stu = existing_app.student
    prog = existing_app.program
    term = existing_app.banner_term
    date = (term.StartDate.to_date) + 2

    travel_to date do
      pop_transcript(stu, 12, 3.0, term.prev_term)
      post :create, {:adm_tep => {
          :student_id => stu.id,
          :Program_ProgCode => prog.id
        }
      }

      assert_equal flash[:notice], "Application not saved."
      assert_response :success
    end
  end

  test "should get edit" do


    app = AdmTep.first
    term = app.banner_term
    date = (term.EndDate.to_date)
    travel_to date do
      allowed_roles.each do |r|
        load_session(r)
        get :edit, {:id => app.id}
        assert_response :success
        assert_equal assigns(:application), app
        assert_equal assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
        assert_equal assigns(:student), Student.find(app.student_id)
      end
    end
  end

  test "should not get edit bad id" do
    load_session("admin")
    assert_raises(ActiveRecord::RecordNotFound) { get :edit, {id: "badid"} }
  end

  test "should post update" do
    app = AdmTep.find_by(:TEPAdmit => nil)
    allowed_roles.each do |r|

      puts "running test as #{r}"
      load_session(r)
      term = app.banner_term
      date = (term.StartDate.to_date) + 10
    
      travel_to date do
        pop_transcript(app.student, 12, 3.0, term.prev_term)

        PraxisSubtestResult.delete_all
        PraxisResult.delete_all
        
        pop_praxisI app.student, true
        post :update, {
              :id => app.id,
              :adm_tep => {
                :TEPAdmit => "true",
                :TEPAdmitDate => date.to_s,
                :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
                }
            }


        assert assigns(:letter).valid?, assigns(:letter).inspect
        assert assigns(:application).valid?, assigns(:application).errors.full_messages 
        assert_redirected_to banner_term_adm_tep_index_path(app.banner_term.id)
        assert_equal flash[:notice], "Student application successfully updated"

        puts assigns(:application).student_file.destroy
      end
        
      #reset everything
      app.update({
        :TEPAdmit => nil,
        :TEPAdmitDate => nil,
        :student_file_id => nil
        })
      app.save

    end
  end

  test "should not post update bad date" do
    app = AdmTep.first

    #make a file for this app
    letter = attach_letter(app)
    app.student_file_id = letter.id
    term = app.banner_term
    next_exclusive_term = BannerTerm.where("StartDate > ?", term.EndDate).first 
    pop_transcript(app.student, 12, 3.0, term.prev_term)

    app.save

    #the next term that starts after this term finishes
    date = (next_exclusive_term.StartDate.to_date) + 10

    travel_to date do
      load_session("admin")

      post :update, {
            :id => app.id,
            :adm_tep => {
              :TEPAdmit => "true",
              :TEPAdmitDate => date.strftime("%m/%d/%Y")
              }
          }
      assert_equal flash[:notice], "Application must be processed in its own term."
      assert_response :success
      assert_equal assigns(:term), app.banner_term
      assert_equal assigns(:student), app.student
    end
  end

  test "should not post update no admission decision" do
    app = AdmTep.first
    term = app.banner_term
    date = (term.StartDate.to_date) + 10
    travel_to date do
      load_session("admin")

      letter = File.new("test/fixtures/test_letter.docx")
      post :update, {
            :id => app.id,
            :adm_tep => {
              :TEPAdmitDate => date.strftime("%m/%d/%Y")
              }
          }
      assert_equal flash[:notice], "Please make an admission decision for this student."
      assert_response :success
    end
  end

  test "should not post update bad app" do
    app = AdmTep.first
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)

    term = app.banner_term
    date = (term.StartDate.to_date) + 10
    travel_to date do
      load_session("admin")

      post :update, {
            :id => app.id,
            :adm_tep => {
              :TEPAdmit => "true",
              :TEPAdmitDate => ""
              }
          }
      assert_response :success
      assert_equal flash[:notice], "Error in saving application."
      assert_equal assigns(:term), app.banner_term
      assert_equal assigns(:student), app.student
    end
  end

  test "should get index" do
    expected_term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    expected_date = (expected_term.StartDate.to_date) + 10
    travel_to expected_date do
      allowed_roles.each do |r|
        load_session(r)
        get :index
        assert_response :success
        expected_applications = AdmTep.all.by_term(expected_term)
        assert_equal assigns(:applications).to_a, expected_applications.to_a
      end
    end 
  end

  test "should get index with term" do
    #should be accessible for admin and staff only
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)

    allowed_roles.each do |r|
      load_session(r)
      get :index, {:banner_term_id => term.BannerTerm}
      assert_response :success
      assert_equal assigns(:applications).to_a, AdmTep.all.by_term(term).to_a
    end
  end   

  test "should post choose" do
    allowed_roles.each do |r|
      load_session(r)
      term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :back})
      term_int = term.BannerTerm

      post :choose, {
        :adm_tep_id => "pick",
        :banner_term => {
          :menu_terms => term_int
        }
      }

      assert_redirected_to banner_term_adm_tep_index_path(term_int)
    end
  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      app = AdmTep.first
      get :show, {id: app.id}
      assert_response :success
      assert_equal assigns(:app), app
      assert_equal assigns(:term), app.banner_term
      assert_equal assigns(:student), app.student
    end
  end

  test "should not get show bad id" do
    load_session("admin")
    assert_raises(ActiveRecord::RecordNotFound) { get :show, {id: "badid"} }
  end

  #TODO tests for download action

  #TESTS FOR UNAUTHORIZED USERS


    #TESTS FOR UNPERMITTED USERS (advisor, stu_labor)


  test "should not post create bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      stu = Student.first
      post :create, {:adm_tep => {
        :student_id => stu.id}
      }
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get edit bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      app = AdmTep.first
      get :edit, {:id => app.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post update bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)

      post :update, {
            :id => "who cares",
            :adm_tep => {
              }
          }
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get index bad role" do
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index 
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get show bad role" do
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :show, {id: "who cares"}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get download bad role" do
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :download, {adm_tep_id: "who cares"}
      assert_redirected_to "/access_denied"
    end
  end

  private
  def attach_letter(app)
    letter = StudentFile.create({
        :student_id => app.student.id,
        :active => true,
        :doc => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
      })

    letter.save
    return letter
  end


end
