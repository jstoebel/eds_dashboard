require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

class AdmStControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "staff"]    #only these roles are allowed access
  all_roles = Role.all.pluck :RoleName
  #TESTS FOR PERMITTED USERS (ADMIN AND STAFF)

  let(:term_today){FactoryGirl.create :banner_term, {:StartDate => Date.today,
        :EndDate => Date.today + 10
      }}

  describe "should get index" do

    before do
      @term = term_today
      @apps = FactoryGirl.create_list :accepted_adm_st, 5, {:BannerTerm_BannerTerm => @term.id}
    end

    allowed_roles.each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end

        test "should get index" do
          #should be accessible for admin and staff only

          get :index
          assert_response :success, "unexpected http response, role=#{r}"
          binding.pry
          assert_equal assigns(:applications).to_a, @apps
        end # test

        test "should get index with term" do
          #should be accessible for admin and staff only

          get :index, params: {:banner_term_id => @term.BannerTerm}
          assert_response :success, "unexpected http response, role=#{r}"
          assert_equal assigns(:applications).to_a, @apps
        end # test
      end # roles
    end # inner describe
  end # outer describe

  describe "new" do

    allowed_roles.each do |r|

      describe "as #{r}" do

        before do
          load_session(r)

          @expected_students = FactoryGirl.create_list :admitted_student, 5
          # these students should be ignored
          other_student = FactoryGirl.create :student
          other_admitted_student = FactoryGirl.create :admitted_student, :EnrollmentStatus => "Dropped"

          @expected_terms = FactoryGirl.create_list :banner_term, 5, :StartDate => 1.year.ago, :EndDate => 2.years.ago

          #lets try to make a new app with a date in the same term as an existing app
          existing_app = FactoryGirl.create :accepted_adm_st
          app_term = existing_app.BannerTerm_BannerTerm
          date_to_use = (BannerTerm.find(app_term).StartDate.to_date) + 2
          FactoryGirl.create :banner_term, {:StartDate => (2.years.ago) -10, :EndDate => (2.years.ago) -1}
        end

        test "should get new" do
          this_term = term_today
          get :new

          expected_terms = BannerTerm.actual.where("EndDate >= ?", 2.years.ago).order(BannerTerm: :asc).to_a

          assert_equal assigns(:students).to_a.sort, @expected_students.to_a.sort
          assert_equal assigns(:terms).to_a.sort, expected_terms.to_a.sort # This sometimes fails, we do not know why...
          assert_response :success, "unexpected http response, role=#{r}"
        end

        test "should not get new outside term" do
          this_term = FactoryGirl.create :banner_term, {:StartDate => 10.days.ago,
            :EndDate => 1.day.ago
          }
         get :new
         assert_redirected_to adm_st_index_path
         assert_equal flash[:info], "No Berea term is currently in session. You may not add a new student to apply."
        end

        test "should get edit" do
          allowed_roles.each do |r|
            load_session(r)
            app = FactoryGirl.create :accepted_adm_st
            get :edit, params: {:id => app.id}
            assert_response :success, "unexpected http response, role=#{r}"
            assert_equal assigns(:app), app
            assert_equal assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
            assert_equal assigns(:student), Student.find(app.student_id)
          end # each loop
        end # test
      end # inner describe
    end # allowed roles loop

    (all_roles - allowed_roles).each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end

        test "redirects to access denied" do
          get :new
          assert_redirected_to "/access_denied"
        end

      end # inner describe
    end # roles loop
  end

  describe "should post create" do
    before do
      @stu = FactoryGirl.create :admitted_student
      @term = @stu.adm_tep.first.banner_term.next_term
    end

    allowed_roles.each do |r|
      test "as #{r}" do
        load_session(r)
        app_attrs = FactoryGirl.attributes_for :pending_adm_st, {:student_id => @stu.id,
          :BannerTerm_BannerTerm => @term.id
        }
        post :create, params: {:adm_st => app_attrs}

        assert_redirected_to adm_st_index_path, "unexpected http response, role=#{r}"
        assert_equal assigns(:app).student_id, @stu.id
        assert_equal flash[:info], "New application added for #{@stu.name_readable(file_as=true)}"

      end # test

      test "should not post create bad params" do
        load_session(r)
        app_attrs = FactoryGirl.attributes_for :pending_adm_st, {:student_id => @stu.id,
          :BannerTerm_BannerTerm => nil
        }
        post :create, params: {:adm_st => {
           :student_id=> @stu.id}
        }

        assert_response :success
        assert_equal flash[:info], "Application not saved."
      end

    end # roles loop

    (all_roles - allowed_roles).each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end

        test "redirects to access denied" do
          app_attrs = FactoryGirl.attributes_for :pending_adm_st, {:student_id => @stu.id,
            :BannerTerm_BannerTerm => @term.id
          }
          post :create, params: {:adm_st => app_attrs}
          assert_redirected_to "/access_denied"
        end
      end # inner describe
    end # roles loop
  end # describe

  describe "edit" do

    allowed_roles.each do |r|

      describe "as #{r}" do

        before do
          load_session(r)

        end

        test "should get edit" do
           app = FactoryGirl.create :pending_adm_st
           get :edit, params: {:id => app.id}
           assert_response :success, "unexpected http response, role=#{r}"
           assert_equal assigns(:app), app
           assert_equal assigns(:term), BannerTerm.find(app.BannerTerm_BannerTerm)
           assert_equal assigns(:student), Student.find(app.student_id)
        end

        test "should not get edit bad id" do
          assert_raises(ActiveRecord::RecordNotFound) { get :edit, params: {id: "badid"} }
        end

      end # inner describe

    end # allowed roles loop

    (all_roles - allowed_roles).each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end

        test "redirects to access denied" do
          app = FactoryGirl.create :pending_adm_st
          get :edit, params: {:id => app.id}
          assert_redirected_to "/access_denied"
        end

        end # inner describe
    end # roles loop
  end

   describe "should post update" do

     allowed_roles.each do |r|
      before do
        load_session(r)
      end

      describe "as #{r}" do

        before do
           @stu = FactoryGirl.create :admitted_student
           # make a term that starts AFTER the term the student was admitted
           term_admitted = @stu.adm_tep.first.banner_term
           @term = FactoryGirl.create :banner_term, {:StartDate => (term_admitted.EndDate) + 1,
            :EndDate => (term_admitted.EndDate) + 10}

            @app = FactoryGirl.create :pending_adm_st, {:banner_term => @term}

        end

        test "should post create" do
           post :update, params: {
                 :id => @app.id,
                 :adm_st => {
                   :STAdmitted => true,
                   :STAdmitDate => @term.StartDate
                   }
               }
           assert assigns(:app).valid?, assigns(:app).errors.full_messages
           assert_redirected_to adm_st_index_path
        end # test

        test "should not post create -- no admit decision" do
           post :update, params: {
                 :id => @app.id,
                 :adm_st => {
                   :STAdmitted => nil,
                   :STAdmitDate => @term.StartDate
                   }
               }
           assert_response :success
           assert_equal ["Please make an admission decision for this student."], assigns(:app).errors[:STAdmitted]
           assert_equal assigns(:term), BannerTerm.find(@app.BannerTerm_BannerTerm)
           assert_equal assigns(:student), Student.find(@app.student_id)

        end # test

      end # inner describe
     end # roles loop

     # bad roles - access denied
     (all_roles - allowed_roles).each do |r|
       test "as #{r}, access_denied" do
          load_session(r)
         stu = FactoryGirl.create :admitted_student
         app = FactoryGirl.create :pending_adm_st, {:student => stu,
           :banner_term => stu.adm_tep.first.banner_term
         }

         post :update, params: {
               :id => app.id,
               :adm_st => {
                 :STAdmitted => "true"
                 }
             }
         assert_redirected_to "/access_denied"
       end

     end # roles loop

   end #outer describe

   test "should get edit_st_paperwork" do
     allowed_roles.each do |r|
       load_session(r)
       app = FactoryGirl.create :accepted_adm_st
       get :edit_st_paperwork, params: {adm_st_id: app.id}
       assert_response :success, "unexpected http response, role=#{r}"
       assert_equal assigns(:app), app
       assert_equal assigns(:student), app.student
       assert_equal assigns(:terms), BannerTerm.where("BannerTerm > ?", app.BannerTerm_BannerTerm).where("BannerTerm < ?", 300000 ).order(:BannerTerm)
     end
   end
 #
   test "should not get edit_st_paperwork bad id" do
     load_session("admin")
     assert_raises(ActiveRecord::RecordNotFound) { get :edit_st_paperwork, params: {adm_st_id: "badid"} }
   end

   test "should post update_st_paperwork" do
     allowed_roles.each do |r|
       load_session(r)
       stu = FactoryGirl.create :admitted_student
       app = FactoryGirl.build :accepted_adm_st, {:student_id => stu.id,
          :BannerTerm_BannerTerm => BannerTerm.current_term({exact: false, plan_b: :back}).id}
       app.save
       puts app.errors.full_messages
       post :update_st_paperwork, params: {
         adm_st_id: app.id,
         :adm_st => {
           :background_check => 1
         }
       }


       assert_redirected_to adm_st_index_path
       assert_equal flash[:info], "Record updated for #{ApplicationController.helpers.name_details(app.student, file_as=true)}"
     end
   end

   describe "destory" do

    # allowed users
    allowed_roles.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
          @stu = FactoryGirl.create :admitted_student
        end

        test "should destroy" do
          app = FactoryGirl.create(:pending_adm_st, {:student_id => @stu.id,
             :BannerTerm_BannerTerm => @stu.adm_tep.first.banner_term.id})
          post :destroy, params: {:id => app.id}
          assert_equal(app, assigns(:app))
          assert_equal flash[:info], "Deleted Successfully!"
          assert assigns(:app).destroyed?
          assert_redirected_to(banner_term_adm_st_index_path(assigns(:app).BannerTerm_BannerTerm)) #Could not determine banner_term
        end # test

        [:accepted_adm_st, :denied_adm_st].each do |status|
          test "shouldn't destory - #{status}" do
            app = FactoryGirl.create(status, {:student_id => @stu.id,
                 :BannerTerm_BannerTerm => @stu.adm_tep.first.banner_term.id})
            post :destroy, params: {:id => app.id}
            assert_equal(app, assigns(:app))
            assert_equal flash[:info], "Could not successfully delete record!"
            assert_redirected_to(banner_term_adm_st_index_path(assigns(:app).BannerTerm_BannerTerm)) #Could not determine banner_term
          end # test
        end # status loop

      end # inner describe
    end # roles loop

    # not allowed users
    (all_roles - allowed_roles).each do |r|
      test "as #{r} shouldn't destory" do
        stu = FactoryGirl.create :admitted_student
        term = FactoryGirl.create :banner_term
        app = FactoryGirl.create :accepted_adm_st, {:student => stu, :banner_term => term}
        load_session(r)
        post :destroy, params: {:id => app.id}
        assert_redirected_to "/access_denied"
      end # test
    end # roles loop

  end # describe

   test "should post choose" do
     allowed_roles.each do |r|
       load_session(r)
       term = FactoryGirl.create :banner_term

       post :choose, params: {
         :adm_st_id => "pick",
         :banner_term => {
           :menu_terms => term.id
         }
       }

       assert_redirected_to banner_term_adm_st_index_path(term.id)
     end
   end

 #  #TESTS FOR UNPERMITTED USERS (advisor, stu_labor)
 #
   test "should not get index bad role" do
     term = FactoryGirl.create :banner_term
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
       stu = FactoryGirl.create :accepted_adm_st
       post :create, params: {:adm_st => {
         :student_id => stu.id}
       }
       assert_redirected_to "/access_denied"
     end
   end

   test "should not get edit bad role" do
     (role_names - allowed_roles).each do |r|
       load_session(r)
       app = FactoryGirl.create :accepted_adm_st
       get :edit, params: {:id => app.id}
       assert_redirected_to "/access_denied"
     end
   end

   test "should not post update bad role" do
     (role_names - allowed_roles).each do |r|
       load_session(r)
       stu = FactoryGirl.create :admitted_student
       app = FactoryGirl.build :accepted_adm_st, {:student_id => stu.id,
         :BannerTerm_BannerTerm => stu.adm_tep.first.banner_term.next_term.id
       }

       #restore app to a pre decision state
       app.STAdmitted = nil
       app.STAdmitDate = nil
       app.save

       post :update, params: {
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
       app = FactoryGirl.create :accepted_adm_st
       get :edit_st_paperwork, params: {adm_st_id: app.id}
       assert_redirected_to "/access_denied"

     end
   end

   test "should not post update_st_paperwork bad role" do
     (role_names - allowed_roles).each do |r|
       load_session(r)
       post :update_st_paperwork, params: {:adm_st_id => "who_cares"}
       assert_redirected_to "/access_denied"
     end
   end


end
