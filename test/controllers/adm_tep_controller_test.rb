
require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

require 'factory_girl'
class AdmTepControllerTest < ActionController::TestCase
  fixtures :all

  allowed_roles = ["admin", "staff"]    #only these roles are allowed access
  all_roles = Role.all.pluck :RoleName
  describe "new" do
    before do
      @prospectives = FactoryGirl.create_list :student, 5
      FactoryGirl.create_list :admitted_student, 5
      @term = FactoryGirl.create :banner_term, {:StartDate => 10.days.ago,
        :EndDate => 10.days.from_now}
      end
    allowed_roles.each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end

        test "should get" do
          get :new

          assert_response :success
          assert_equal @prospectives.to_a.sort, assigns(:students).to_a.sort
          assert_equal  Program.where("Current = 1").to_a, assigns(:programs).to_a
        end

      end # inner describe
    end # roles loop

    (all_roles - allowed_roles).each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end

        test "should not get -- access denied" do
          get :new
          assert_redirected_to "/access_denied"
        end

      end
    end
  end # outer describe

  describe "create" do
    before do
      @stu = FactoryGirl.create :student

      @term = FactoryGirl.create :banner_term, {:StartDate => 10.days.ago,
        :EndDate => 10.days.from_now
      }
      @prog = FactoryGirl.create :program
      pop_transcript(@stu, 12, 3.0, @term)
      @app_attrs = FactoryGirl.attributes_for :adm_tep, {:student_id => @stu.id,
        :BannerTerm_BannerTerm => @term.id,
        :Program_ProgCode => @prog.id,
        :TEPAdmit => nil,
        :TEPAdmitDate => nil,
        :student_file => nil
      }
    end
    allowed_roles.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
        end

        test "should create" do
            post :create, {:adm_tep => @app_attrs}
            assert assigns(:app).valid?, assigns(:app).errors.full_messages
            assert_redirected_to adm_tep_index_path
            assert_equal flash[:notice], "New application added: #{@stu.name_readable}-#{@prog.EDSProgName}"
        end

        test "should not create -- bad params" do
          @app_attrs[:BannerTerm_BannerTerm] = nil
          post :create, {:adm_tep => @app_attrs}
          assert_not assigns(:app).valid?
          assert_equal flash[:notice], "Application not saved."
          assert_response :success
        end

      end # inner describe
    end # roles loop

    (all_roles - allowed_roles).each do |r|
      
      test "should not post create as #{r} -- access denied" do
        load_session(r)
        post :create, {:adm_tep => @app_attrs}
        assert_redirected_to "/access_denied"
      end
    end # roles loop

  end # outer describe
  
  describe "edit" do
    before do
      @app = FactoryGirl.create :adm_tep
    end
    allowed_roles.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
        end

        test "should get edit" do
          get :edit, {:id => @app.id}
          assert_response :success
          assert_equal assigns(:application), @app
          assert_equal assigns(:term), @app.banner_term
          assert_equal assigns(:student), @app.student
        end

        test "should not get id -- bad id" do
          assert_raises(ActiveRecord::RecordNotFound) { get :edit, {id: "badid"} }
        end

      end # inner describe
    end # roles loop

    (all_roles - allowed_roles).each do |r|
      
      test "should not get edit #{r} -- access denied" do
        load_session(r)
        get :edit, {:id => @app.id}
        assert_redirected_to "/access_denied"
      end
      
    end # roles loop

  end # outer describe  

  describe "update" do
    before do
      @app = FactoryGirl.create :adm_tep 
      pop_transcript(@app.student, 12, 3.0, @app.banner_term.prev_term)
      pop_praxisI(@app.student, true)
    end
    allowed_roles.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
        end

        test "should post update" do
          post :update, { 
            :id => app.id,
            :adm_tep => {
              :TEPAdmit => true,
              :TEPAdmitDate => @app.banner_term.StartDate,
              :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
              }
          }
          
          assert assigns(:application).valid?, assigns(:application).errors.full_messages
          assert_redirected_to banner_term_adm_tep_index_path(app.banner_term.id)
          assert_equal flash[:notice], "Student application successfully updated"
        end

        test "should not post update -- bad params" do
          post :update, {
                :id => app.id,
                :adm_tep => {
                  :TEPAdmit => "true",
                  :TEPAdmitDate => nil,
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

      end # inner describe
    end # roles loop

    (all_roles - allowed_roles).each do |r|
      
      test "should not post update as #{r} -- access denied" do
        load_session(r)
          post :update, { 
              :id => app.id,
              :adm_tep => {
                :TEPAdmit => true,
                :TEPAdmitDate => @app.banner_term.StartDate,
                :letter => Paperclip.fixture_file_upload("test/fixtures/test_file.txt")
                }
            }
        assert_redirected_to "/access_denied"

      end
    end # roles loop

  end # outer describe


 describe "index" do
    before do
      @applications = FactoryGirl.create_list :adm_tep, 5
    end
    
    allowed_roles.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
        end

        test "should get index" do
          get :index
          assert_response :success
          assert_equal assigns(:applications).to_a.sorted, @applications.sorted
          # test for @current_term, @term, @menu_terms
          
          assert_equal BannerTerm.current_term(exact: false, plan_b: :back), assigns(:current_term)
          assert_equal assigns(:term), assigns(:current_term)
          assert_equal BannerTerm.all.joins(table_name).group(term_col), assigns(:menu_terms)
        end
        
        test "should get index -- with term" do
          term_to_use = @applications.first.banner_term
          get :index, :banner_term_id => term_to_use.id
          assert_response :success
          assert_equal assigns(:applications).to_a.sorted, @applications.sorted
          
          assert_equal BannerTerm.current_term(exact: false, plan_b: :back), assigns(:current_term)
          assert_equal BannerTerm.find(term_to_use.id), assigns(:term)
          assert_equal BannerTerm.all.joins(table_name).group(term_col), assigns(:menu_terms)
        end

      end # inner describe
    end # roles loop

    (all_roles - allowed_roles).each do |r|
      
      test "should not get index as #{r} -- access denied" do
        load_session(r)
        get :index
        assert_redirected_to "/access_denied"
      end
    end # roles loop

  end # outer describe



 describe "show" do
    before do
      @app = FactoryGirl.create :adm_tep
    end
    
    allowed_roles.each do |r|
      describe "as #{r}" do
        
        before do
          load_session(r)
        end

        test "should get show" do
          get :show, {id: @app.id}
          assert_response :success
          assert_equal assigns(:app), @app
          assert_equal assigns(:term), @app.banner_term
          assert_equal assigns(:student), @app.student
        end
        
        test "should not show -- bad params" do
          assert_raises(ActiveRecord::RecordNotFound) { get :show, {id: "badid"} }
        end

      end # inner describe
    end # roles loop

    (all_roles - allowed_roles).each do |r|
      
      test "should not showw as #{r} -- access denied" do
        load_session(r)
        get :show, {id: @app.id}
        assert_redirected_to "/access_denied"
      end
    end # roles loop

  end # outer describe

  

  # test "should post choose" do
  #   allowed_roles.each do |r|
  #     load_session(r)
  #     term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :back})
  #     term_int = term.BannerTerm
  #
  #     post :choose, {
  #       :adm_tep_id => "pick",
  #       :banner_term => {
  #         :menu_terms => term_int
  #       }
  #     }
  #
  #     assert_redirected_to banner_term_adm_tep_index_path(term_int)
  #   end
  # end
  #
  

  #
  # #TODO tests for download action
  #
  # #TESTS FOR UNAUTHORIZED USERS
  #
  #
  #   #TESTS FOR UNPERMITTED USERS (advisor, stu_labor)
  #
  #
  # test "should not post create bad role" do
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #     stu = Student.first
  #     post :create, {:adm_tep => {
  #       :student_id => stu.id}
  #     }
  #     assert_redirected_to "/access_denied"
  #   end
  # end
  #
  # test "should not get edit bad role" do
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #     app = FactoryGirl.create :adm_tep
  #     get :edit, {:id => app.id}
  #     assert_redirected_to "/access_denied"
  #   end
  # end
  #
  # test "should not post update bad role" do
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #
  #     post :update, {
  #           :id => "who cares",
  #           :adm_tep => {
  #             }
  #         }
  #     assert_redirected_to "/access_denied"
  #
  #   end
  # end
  #
  # test "should not get index bad role" do
  #   term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #     get :index
  #     assert_redirected_to "/access_denied"
  #   end
  # end
  #
  # test "should not get show bad role" do
  #   term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #     get :show, {id: "who cares"}
  #     assert_redirected_to "/access_denied"
  #   end
  # end
  #
  # test "should not get download bad role" do
  #   term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #     get :download, {adm_tep_id: "who cares"}
  #     assert_redirected_to "/access_denied"
  #   end
  # end
  #
  # test "should delete the record" do
  #   # use assigns(:app)
  #
  #   #1 create an example adm_tep record
  #   stu = FactoryGirl.create :student
  #   term = BannerTerm.current_term({:exact => false, :plan_b => :back})
  #   pop_transcript(stu, 12, 3.0, term.prev_term)
  #   pop_praxisI(stu, true)
  #
  #   app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => nil,
  #     :TEPAdmitDate => nil,
  #     :student_id => stu.id,
  #     :student_file_id =>nil,
  #     :Program_ProgCode => Program.first.id,
  #     :BannerTerm_BannerTerm => term.id
  #   }
  #
  #   allowed_roles.each do |r|
  #     load_session(r)
  #     expected_app = AdmTep.create app_attrs
  #     #2 make the request
  #     post :destroy, {:id => expected_app.id}
  #
  #     #3 make your assertions
  #     # assigned record is the same
  #     assert_equal expected_app, assigns(:app)    #finds (:) generated in controller
  #     assert assigns(:app).destroyed?             # failed for expected_app
  #     assert_equal flash[:notice], "Record deleted successfully"    #assert flash message
  #     assert_redirected_to banner_term_adm_tep_index_path(assigns(:app).BannerTerm_BannerTerm)      #asserted equal. can use expected_app.BannerTerm_BannerTerm?#method(instance variable.object attribute)
  #
  #   end
  # end
  #
  # test "should not delete record bad role" do
  #   stu = FactoryGirl.create :student
  #   stu_file = FactoryGirl.create :student_file , {:student_id => stu.id}
  #   term = BannerTerm.current_term({:exact => false, :plan_b => :back})
  #   pop_transcript(stu, 12, 3.0, term.prev_term)
  #   pop_praxisI(stu, true)
  #
  #   app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => true,
  #     :TEPAdmitDate => Date.today,
  #     :student_id => stu.id,
  #     :student_file_id => stu_file.id,
  #     :Program_ProgCode => Program.first.id,
  #     :BannerTerm_BannerTerm => term.id
  #   }
  #   expected_app = AdmTep.create app_attrs
  #   (role_names - allowed_roles).each do |r|
  #     load_session(r)
  #
  #     post :destroy, {:id => expected_app.id}
  #     assert_redirected_to "/access_denied"
  #   end
  # end
  #
  # test 'should not delete record not pending' do
  #   stu = FactoryGirl.create :student
  #   stu_file = FactoryGirl.create :student_file, {:student_id => stu.id}
  #   term = BannerTerm.current_term({:exact => false, :plan_b => :back})
  #   pop_transcript(stu, 12, 3.0, term.prev_term)
  #   pop_praxisI(stu, true)
  #
  #   app_attrs = FactoryGirl.attributes_for :adm_tep, {:TEPAdmit => true,
  #     :TEPAdmitDate => Date.today,
  #     :student_id => stu.id,
  #     :student_file_id => stu_file.id,
  #     :Program_ProgCode => Program.first.id,
  #     :BannerTerm_BannerTerm => term.id
  #   }
  #   expected_app = AdmTep.create app_attrs
  #
  #   allowed_roles.each do |r|
  #     load_session(r)
  #     post :destroy, {:id => expected_app.id}
  #     assert_equal flash[:notice], "Record cannot be deleted"
  #     #assert_redirected_to banner_term_adm_tep_index_path( assigns(:app.BannerTerm_BannerTerm))
  #     assert_redirected_to banner_term_adm_tep_index_path(assigns(:app).BannerTerm_BannerTerm)
  #   end
  # end


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
