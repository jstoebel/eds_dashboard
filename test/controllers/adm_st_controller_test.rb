require 'test_helper'
class AdmStControllerTest < ActionController::TestCase

  test "should get index" do
    #should be accessible for admin and staff only
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)

    ["admin", "staff"].each do |r|
      load_session(r)
      get :index
      assert_response :success
      py_assert assigns(:applications).to_a, AdmSt.all.by_term(term).to_a
    end
  end

  # test "should get show" do
  #   app = AdmSt.first
  #   ["admin", "staff"].each do |r|
  #     load_session(r)
  #     get :show, id: app.id
  #     get(:show, {"id" => app.id})
  #     assert_response :success
  #     py_assert(assigns(:app), app)
  #     py_assert(assigns(:term), app.BannerTerm_BannerTerm)
  #     py_assert(assigns(:student), Student.find(app.Student_Bnum))
  #   end

  # end

  test "should get new" do
    #should be accessible for admin and staff only
    travel_to Date.new(2015, 03, 15) do
      ["admin", "staff"].each do |r|
        term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        load_session(r)
        get :new
        expected = Student.where("ProgStatus = 'Candidate' and EnrollmentStatus='Active Student' and Classification='Senior'").order(LastName: :asc)
        py_assert assigns(:students).to_a, expected.to_a
        assert_response :success
      end
    end
  end

  test "should get new outside term" do
    #when this method is called outside a term
    travel_to Date.new(2015, 12, 31) do
      ["admin", "staff"].each do |r|
        load_session(r)
        get :new
        assert_redirected_to adm_st_index_path
        py_assert flash[:notice], "No Berea term is currently in session. You may not add a new student to apply."
      end
    end 
  end

  test "should post create" do
    #post a valid adm_st application
      #we should...
      #create a new app with the student's B#, 
      #be redirected and 
      #have a flash message

    travel_to Date.new(2015, 03, 15) do
      ["admin", "staff"].each do |r|
        AdmSt.delete_all      #for this test, delete all applications to avoid conflicting open applications
        load_session(r)
        term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        stu = Student.where(ProgStatus: "Candidate").first
        post :create, {:adm_st => {
          :Student_Bnum => stu.Bnum}
        }
        assert_redirected_to adm_st_index_path, "errors are " + assigns(:app).errors.full_messages.to_s
        py_assert assigns(:app).Student_Bnum, stu.Bnum
        py_assert flash[:notice], "New application added for #{ApplicationController.helpers.name_details(stu, file_as=true)}"
      end
    end
  end

  test "should not post create outside term" do
    #post outside a term
      #we should be redirected and post a flash message

    travel_to Date.new(2015, 12, 31) do
      ["admin", "staff"].each do |r|
        AdmSt.delete_all      #for this test, delete all applications to avoid conflicting open applications
        load_session(r)
        # term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        stu = Student.where(ProgStatus: "Candidate").first
        post :create, {:adm_st => {
          :Student_Bnum => stu.Bnum}
        }
        assert_redirected_to adm_st_index_path
        py_assert flash[:notice], "No Berea term is currently in session. You may not add a new student to apply."
      end
    end
  end

  test "should not post create bad app" do
    #post an invalid adm_st application inside a term
      #we should have an http response of 200 and a flash message

    #lets try to make a new app with a date in the same term as an existing app
    existing_app = AdmSt.first
    app_term = existing_app.BannerTerm_BannerTerm
    date_to_use = BannerTerm.find(app_term).StartDate + 2


    travel_to date_to_use do
      ["admin", "staff"].each do |r|
        #not deleting prior applications to prevent appication from being saved
        load_session(r)
        # term = ApplicationController.helpers.current_term({:exact => true, :date => Date.today})
        stu = existing_app.student
        post :create, {:adm_st => {
          :Student_Bnum => stu.Bnum}
        }

        assert_redirected_to adm_st_index_path
        py_assert assigns(:current_term), 201511
        # assert_response :success
        # py_assert flash[:notice], "Application not saved."
      end
    end
  end

  test "should not get index" do
    term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    (role_names - ["admin", "staff"]).each do |r|
      load_session(r)
      get :index
      assert_redirected_to "/access_denied"
    end
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should get create" do
  #   get :create
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit
  #   assert_response :success
  # end

  # test "should get update" do
  #   get :update
  #   assert_response :success
  # end

end
