require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess
class AdmStControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "staff"]    #only these roles are allowed access

  #TESTS FOR PERMITTED USERS (ADMIN AND STAFF)

  test "should get index" do
    #should be accessible for admin and staff only
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)

    allowed_roles.each do |r|
      load_session(r)
      get :index
      assert_response :success, "unexpected http response, role=#{r}"
      assert_equal assigns(:applications).to_a, AdmSt.all.by_term(term).to_a
    end
  end

  test "should get index with term" do
    #should be accessible for admin and staff only
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)

    allowed_roles.each do |r|
      load_session(r)
      get :index, {:banner_term_id => term.BannerTerm}
      assert_response :success, "unexpected http response, role=#{r}"
      assert_equal assigns(:applications).to_a, AdmSt.all.by_term(term).to_a
    end
  end   


  test "should get new" do
    #should be accessible for admin and staff only
    travel_to Date.new(2015, 03, 15) do
      allowed_roles.each do |r|
        term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        load_session(r)
        get :new
        expected = Student.where("ProgStatus = 'Candidate' and EnrollmentStatus='Active Student' and Classification='Senior'").order(LastName: :asc)
        assert_equal assigns(:students).to_a, expected.to_a
        assert_response :success, "unexpected http response, role=#{r}"
      end
    end
  end

  test "should not get new outside term" do
    #when this method is called outside a term
    travel_to Date.new(2015, 12, 31) do
      load_session("admin")
      get :new
      assert_redirected_to adm_st_index_path
      assert_equal flash[:notice], "No Berea term is currently in session. You may not add a new student to apply."
    end 
  end

  test "should post create" do
    #post a valid adm_st application
      #we should...
      #create a new app with the student's B#, 
      #be redirected and 
      #have a flash message

    travel_to Date.new(2015, 03, 15) do
      allowed_roles.each do |r|
        AdmSt.delete_all      #for this test, delete all applications to avoid conflicting open applications
        load_session(r)
        term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        stu = Student.where(ProgStatus: "Candidate").first
        post :create, {:adm_st => {
          :Student_Bnum => stu.Bnum}
        }
        assert_redirected_to adm_st_index_path, "unexpected http response, role=#{r}"
        assert_equal assigns(:app).Student_Bnum, stu.Bnum
        assert_equal flash[:notice], "New application added for #{ApplicationController.helpers.name_details(stu, file_as=true)}"
      end
    end
  end

  test "should not post create outside term" do
    #post outside a term
      #we should be redirected and post a flash message

    travel_to Date.new(2015, 12, 31) do
        AdmSt.delete_all      #for this test, delete all applications to avoid conflicting open applications
        load_session("admin")
        # term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        stu = Student.where(ProgStatus: "Candidate").first
        post :create, {:adm_st => {
          :Student_Bnum => stu.Bnum}
        }
        assert_redirected_to adm_st_index_path
        assert_equal flash[:notice], "No Berea term is currently in session. You may not add a new student to apply."
    end
  end

  test "should not post create bad app" do
    #post an invalid adm_st application inside a term
      #we should have an http response of 200 and a flash message

    #lets try to make a new app with a date in the same term as an existing app
    existing_app = AdmSt.first
    app_term = existing_app.BannerTerm_BannerTerm
    date_to_use = (BannerTerm.find(app_term).StartDate.to_date) + 2

    travel_to date_to_use do
      #not deleting prior applications to prevent appication from being saved
      load_session("admin")
      # term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
      stu = existing_app.student
      post :create, {:adm_st => {
        :Student_Bnum => stu.Bnum}
      }

      assert_response :success
      assert_equal flash[:notice], "Application not saved."
    end
  end

  test "should get edit" do
    allowed_roles.each do |r|
      load_session(r)
      app = AdmSt.first
      get :edit, {:id => app.id}
      assert_response :success, "unexpected http response, role=#{r}"
      assert_equal assigns(:application), app 
      assert_equal assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
      assert_equal assigns(:student), Student.find(app.Student_Bnum)
    end

  end

  test "should not get edit bad id" do
    #should get an error when we pass in a bogus id
    load_session("admin")
    assert_raises(ActiveRecord::RecordNotFound) { get :edit, {id: "badid"} }
  end

  test "should post update" do
    allowed_roles.each do |r|
      load_session(r)
      app = AdmSt.first

      #restore app to a pre decision state
      app.STAdmitted = nil
      app.STAdmitDate = nil
      app.save
      travel_to (app.banner_term.StartDate.to_date) + 1 do
        post :update, {
              :id => app.id,
              :adm_st => {
                :STAdmitted => "true",
                :STAdmitDate => Date.today.strftime("%m/%d/%Y"),
                :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
                }
            }
        assert assigns(:application).valid?, assigns(:application).errors.full_messages
        assert_redirected_to adm_st_index_path
      end
    end
  end

  test "should not post update bad date" do
    app = AdmSt.first
    app.STAdmitted = nil
    app.STAdmitDate = nil
    app.save

    app_term = app.BannerTerm_BannerTerm

    next_term = BannerTerm.where("BannerTerm > ?", app_term).order(:BannerTerm).first
    start_date = (next_term.StartDate).to_date + 1

    # assert false, "app_term is #{app_term} and next_term is #{next_term.BannerTerm}"

    travel_to start_date do
      load_session("admin")
      #try to admit in the following term
      post :update, {
        :id => app.id,
        :adm_st => {
          :STAdmitted => "true"
          }
      }
      assert_response :success
      assert_equal flash[:notice],  "Application must be processed in its own term or the break following."
      assert_equal assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
      assert_equal assigns(:student), Student.find(app.Student_Bnum)
    end
  end

  test "should not post update no decision" do

      load_session("admin")
      app = AdmSt.first
      travel_to (app.banner_term.StartDate.to_date) + 1 do
        app.STAdmitted = nil
        app.STAdmitDate = nil
        assert app.valid?, app.errors.full_messages
        app.save
        post :update, {
          :id => app.id,
          :adm_st => {
            }
        }
      end
      assert_response :success
      assert_equal "Please make an admission decision for this student.", flash[:notice]  
      assert_equal assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
      assert_equal assigns(:student), Student.find(app.Student_Bnum)

  end

  test "should get edit_st_paperwork" do
    allowed_roles.each do |r|
      load_session(r)
      app = AdmSt.first
      get :edit_st_paperwork, {adm_st_id: app.id}
      assert_response :success, "unexpected http response, role=#{r}"    
      assert_equal assigns(:app), app
      assert_equal assigns(:student), app.student
      assert_equal assigns(:terms), BannerTerm.where("BannerTerm > ?", app.BannerTerm_BannerTerm).where("BannerTerm < ?", 300000 ).order(:BannerTerm)
    end
  end

  test "should not get edit_st_paperwork bad id" do
    load_session("admin")
    assert_raises(ActiveRecord::RecordNotFound) { get :edit_st_paperwork, {adm_st_id: "badid"} }
  end

  test "should post update_st_paperwork" do
    allowed_roles.each do |r|
      load_session(r)
      app = AdmSt.first
      post :update_st_paperwork, {
        adm_st_id: app.id,
        :adm_st => {
          :background_check => 1
        }
      }

      assert_redirected_to adm_st_index_path
      assert_equal flash[:notice], "Record updated for #{ApplicationController.helpers.name_details(app.student, file_as=true)}"
    end
  end

  test "should not post update_st_paperwork bad app" do
    #I can't think of a way to cause the record to be invalid in this method.
    #so there may be no need for this test
  end

  test "should get download" do
    #haven't figured out how to test this yet.
    # load_session("admin")
    # app = AdmSt.first
    # app.letter = File.new("test/fixtures/test_letter.docx")
    # app.save
    # get :download, {adm_st_id: app.id}
  end

  test "should not get download bad id" do
    load_session("admin")
    assert_raises(ActiveRecord::RecordNotFound) { get :download, {adm_st_id: "badid"} }
  end

  test "should post choose" do
    allowed_roles.each do |r|
      load_session(r)
      term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :back})
      term_int = term.BannerTerm

      post :choose, {
        :adm_st_id => "pick",
        :banner_term => {
          :menu_terms => term_int
        }
      }

      assert_redirected_to banner_term_adm_st_index_path(term_int)
    end
  end

  #TESTS FOR UNPERMITTED USERS (advisor, stu_labor)

  test "should not get index bad role" do
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index 
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
      stu = Student.where(ProgStatus: "Candidate").first
      post :create, {:adm_st => {
        :Student_Bnum => stu.Bnum}
      }
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get edit bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      app = AdmSt.first
      get :edit, {:id => app.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post update bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      app = AdmSt.first

      #restore app to a pre decision state
      app.STAdmitted = nil
      app.STAdmitDate = nil
      app.save

      post :update, {
            :id => app.id,
            :adm_st => {
              :STAdmitted => "true"
              }
          }
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get edit_st_paperwork bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      app = AdmSt.first
      get :edit_st_paperwork, {adm_st_id: app.id}
      assert_redirected_to "/access_denied"
      
    end
  end

  test "should not post update_st_paperwork bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :update_st_paperwork, {:adm_st_id => "who_cares"}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get download bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :download, {:adm_st_id => "who_cares"}
      assert_redirected_to "/access_denied"
    end
  end

end
