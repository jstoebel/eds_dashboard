require 'test_helper'

class AdmTepControllerTest < ActionController::TestCase

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

  test "should not get new outside term" do
    load_session("admin")
    get :new
    assert_redirected_to adm_tep_index_path
  end

  test "should post create" do
    term = BannerTerm.first
    start_date = (term.StartDate.to_date) + 1

    stu = Student.first
    prog = Program.first
    travel_to start_date do
      allowed_roles.each do |r|
        AdmTep.delete_all   #clear entire table or else the record won't save on the second iteration
        load_session(r)
        post :create, {:adm_tep => {
            :Student_Bnum => stu.Bnum,
            :Program_ProgCode => prog.ProgCode
          }
        }
        assert_redirected_to adm_tep_index_path
        py_assert flash[:notice], "New application added: #{ApplicationController.helpers.name_details(stu)}-#{prog.EDSProgName}"
      end
    end
  end

  test "should not post create not in term" do
    load_session("admin")
    term = BannerTerm.first
    stu = Student.first
    prog = Program.first
    bad_date = (term.EndDate.to_date) + 3
    travel_to bad_date do

      post :create, {:adm_tep => {
          :Student_Bnum => stu.Bnum,
          :Program_ProgCode => prog.ProgCode
        }
      }

      py_assert flash[:notice], "No Berea term is currently in session. You may not add a new student to apply."
      assert_redirected_to adm_tep_index_path
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

      post :create, {:adm_tep => {
          :Student_Bnum => stu.Bnum,
          :Program_ProgCode => prog.ProgCode
        }
      }

      py_assert flash[:notice], "Application not saved."
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
        py_assert assigns(:application), app
        py_assert assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
        py_assert assigns(:student), Student.find(app.Student_Bnum)
      end
    end
  end

  test "should not get edit bad id" do
    load_session("admin")
    assert_raises(ActiveRecord::RecordNotFound) { get :edit, {id: "badid"} }
  end

  test "should post update" do
    app = AdmTep.first
    term = app.banner_term
    date = (term.StartDate.to_date) + 10
    travel_to date do
      allowed_roles.each do |r|
        load_session(r)

        post :update, {
              :id => app.id,
              :adm_tep => {
                :TEPAdmit => "true",
                :TEPAdmitDate => date.strftime("%m/%d/%Y")
                }
            }
        assert_redirected_to adm_tep_index_path
        py_assert flash[:notice], "Student application successfully updated"
      end
    end
  end

  test "should not post update bad date" do
    app = AdmTep.first
    term = app.banner_term
    next_term = BannerTerm.where("BannerTerm > ?", term.BannerTerm).first
    date = (next_term.StartDate.to_date) + 10
    travel_to date do
      load_session("admin")

      post :update, {
            :id => app.id,
            :adm_tep => {
              :TEPAdmit => "true",
              :TEPAdmitDate => date.strftime("%m/%d/%Y")
              }
          }
      py_assert flash[:notice], "Application must be processed in its own term."
      assert_response :success
      py_assert assigns(:term), app.banner_term
      py_assert assigns(:student), app.student
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
      py_assert flash[:notice], "Please make an admission decision for this student."
      assert_response :success
    end
  end

  test "should not post update bad app" do
    app = AdmTep.first
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
      py_assert flash[:notice], "Error in saving application."
      py_assert assigns(:term), app.banner_term
      py_assert assigns(:student), app.student
    end
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end

  # test "should get show" do
  #   get :show
  #   assert_response :success
  # end

end
