
require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess
require 'test_teardown'
require 'factory_girl'
class AdmTepControllerTest < ActionController::TestCase
  fixtures :all
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
        assert_equal Student.all.order(LastName: :asc).select { |s| s.prog_status == "Prospective" && s.EnrollmentStatus == "Active Student"}.to_a, assigns(:students).to_a
        assert_equal  Program.where("Current = 1").to_a, assigns(:programs).to_a

        term_now = BannerTerm.current_term({:exact => false, :plan_b => :back})
        assert_equal BannerTerm.actual.where("BannerTerm >= ?", term_now.id).order(BannerTerm: :asc).to_a, assigns(:terms).to_a
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
    stu = FactoryGirl.create :student
    term = BannerTerm.current_term({:exact => false, :plan_b => :back})
    pop_transcript(stu, 12, 3.0, term.prev_term)
    pop_praxisI(stu, true)

    allowed_roles.each do |r|

      load_session(r)

      app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => nil,
        :TEPAdmitDate => nil,
        :student_id => stu.id,
        :student_file_id =>nil,
        :Program_ProgCode => Program.first.id,
        :BannerTerm_BannerTerm => term.id
      }

      app = AdmTep.create app_attrs

      date = (term.StartDate.to_date) + 10

      travel_to date do
        post :update, {
              :id => app.id,
              :adm_tep => {
                :TEPAdmit => "true",
                :TEPAdmitDate => date.to_s,
                :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
                }
            }

        assert assigns(:application).valid?, assigns(:application).errors.full_messages
        assert_redirected_to banner_term_adm_tep_index_path(app.banner_term.id)
        assert_equal flash[:notice], "Student application successfully updated"

        #tear down for next role
        app.destroy
        assigns(:letter).destroy

      end
    end
  end

  test "should not post update bad date" do

    stu = FactoryGirl.create :student
    term = BannerTerm.current_term({:exact => false, :plan_b => :back})
    pop_transcript(stu, 12, 3.0, term.prev_term)
    pop_praxisI(stu, true)
    next_exclusive_term = BannerTerm.where("StartDate > ?", term.EndDate).first

    #the next term that starts after this term finishes
    date = (next_exclusive_term.StartDate.to_date) + 10

    travel_to date do
      load_session("admin")

      app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => nil,
        :TEPAdmitDate => nil,
        :student_id => stu.id,
        :student_file_id =>nil,
        :Program_ProgCode => Program.first.id,
        :BannerTerm_BannerTerm => term.id
      }

      app = AdmTep.create app_attrs

      post :update, {
            :id => app.id,
            :adm_tep => {
              :TEPAdmit => "true",
              :TEPAdmitDate => date.to_s,
              :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
              }
          }
      assert_equal flash[:notice], "Error in saving application."
      assert assigns(:application).errors[:TEPAdmitDate].include?("Admission date must be before next term begins."),
        assigns(:application).errors.full_messages

      assert_response :success
      assert_equal assigns(:term), app.banner_term
      assert_equal assigns(:student), app.student
    end
  end

  test "should not post update no admission decision" do

    stu = FactoryGirl.create :student
    term = BannerTerm.current_term({:exact => false, :plan_b => :back})
    pop_transcript(stu, 12, 3.0, term.prev_term)
    pop_praxisI(stu, true)

    app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => nil,
      :TEPAdmitDate => nil,
      :student_id => stu.id,
      :student_file_id =>nil,
      :Program_ProgCode => Program.first.id,
      :BannerTerm_BannerTerm => term.id
    }

    app = AdmTep.create app_attrs

    date = (term.StartDate.to_date) + 10
    travel_to date do
      load_session("admin")

      letter = File.new("test/fixtures/test_letter.docx")
      post :update, {
            :id => app.id,
            :adm_tep => {
              :TEPAdmitDate => date.to_s,
              :TEPAdmit => true,
              :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
              }
          }

      assert assigns(:application).errors[:TEPAdmit].include?("Please make an admission decision for this student.")
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
    expected_term = BannerTerm.current_term(exact: false, plan_b: :back)
    allowed_roles.each do |r|
      load_session(r)
      get :index
      assert_response :success
      expected_applications = AdmTep.all.by_term(expected_term)
      assert_equal assigns(:applications).to_a, expected_applications.to_a
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

  test "should delete the record" do
    # use assigns(:app)

    #1 create an example adm_tep record
    stu = FactoryGirl.create :student
    term = BannerTerm.current_term({:exact => false, :plan_b => :back})
    pop_transcript(stu, 12, 3.0, term.prev_term)
    pop_praxisI(stu, true)

    app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => nil,
      :TEPAdmitDate => nil,
      :student_id => stu.id,
      :student_file_id =>nil,
      :Program_ProgCode => Program.first.id,
      :BannerTerm_BannerTerm => term.id
    }

    allowed_roles.each do |r|
      load_session(r)
      expected_app = AdmTep.create app_attrs
      #2 make the request
      post :destroy, {:id => expected_app.id}

      #3 make your assertions
      # assigned record is the same
      assert_equal expected_app, assigns(:app)    #finds (:) generated in controller
      assert assigns(:app).destroyed?             # failed for expected_app
      assert_equal flash[:notice], "Record deleted successfully"    #assert flash message
      assert_redirected_to banner_term_adm_tep_index_path(assigns(:app).BannerTerm_BannerTerm)      #asserted equal. can use expected_app.BannerTerm_BannerTerm?#method(instance variable.object attribute)

    end
  end

  test "should not delete record bad role" do
    stu = FactoryGirl.create :student
    stu_file = FactoryGirl.create :student_file , {:student_id => stu.id}
    term = BannerTerm.current_term({:exact => false, :plan_b => :back})
    pop_transcript(stu, 12, 3.0, term.prev_term)
    pop_praxisI(stu, true)

    app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => true,
      :TEPAdmitDate => Date.today,
      :student_id => stu.id,
      :student_file_id => stu_file.id,
      :Program_ProgCode => Program.first.id,
      :BannerTerm_BannerTerm => term.id
    }
    expected_app = AdmTep.create app_attrs
    (role_names - allowed_roles).each do |r|
      load_session(r)

      post :destroy, {:id => expected_app.id}
      assert_redirected_to "/access_denied"
    end
  end

  test 'should not delete record not pending' do
    stu = FactoryGirl.create :student
    stu_file = FactoryGirl.create :student_file, {:student_id => stu.id}
    term = BannerTerm.current_term({:exact => false, :plan_b => :back})
    pop_transcript(stu, 12, 3.0, term.prev_term)
    pop_praxisI(stu, true)

    app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => true,
      :TEPAdmitDate => Date.today,
      :student_id => stu.id,
      :student_file_id => stu_file.id,
      :Program_ProgCode => Program.first.id,
      :BannerTerm_BannerTerm => term.id
    }
    expected_app = AdmTep.create app_attrs

    allowed_roles.each do |r|
      load_session(r)
      post :destroy, {:id => expected_app.id}
      assert_equal flash[:notice], "Record cannot be deleted"
      #assert_redirected_to banner_term_adm_tep_index_path( assigns(:app.BannerTerm_BannerTerm))
      assert_redirected_to banner_term_adm_tep_index_path(assigns(:app).BannerTerm_BannerTerm)
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
