# == Schema Information
#
# Table name: clinical_sites
#
#  id           :integer          not null, primary key
#  SiteName     :string(45)       not null
#  City         :string(45)
#  County       :string(45)
#  Principal    :string(45)
#  District     :string(45)
#  phone        :string(255)
#  receptionist :string(255)
#  website      :string(255)
#  email        :string(255)
#

require 'test_helper'

class ClinicalSitesControllerTest < ActionController::TestCase

  #all roles have access to this resource
  allowed_roles = ["admin", "advisor", "staff", "student labor"]

  describe "index" do
    allowed_roles.each do |r|
      before do
        load_session(r)
        FactoryGirl.create_list :clinical_site, 5
      end

      test "as #{r} should get" do
        get :index
        assert_response :success
        assert_equal assigns(:sites), ClinicalSite.all
      end
    end
  end


  describe "edit" do
    allowed_roles.each do |r|

      describe "as #{r}" do
        before do
          load_session(r)
          @site = FactoryGirl.create :clinical_site
        end

        test "should get" do
          get :edit, :id => @site.id
          assert_response :success
          assert_equal @site, assigns(:site)
        end

        test "should not get -- bad id" do
          assert_raise(ActiveRecord::RecordNotFound){get :edit, :id => "bad_id"}
        end
      end
    end
  end

  describe "update" do
    allowed_roles.each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
          @site = FactoryGirl.create :clinical_site
        end

        test "should post update" do

          @site.SiteName = "changed!"
          update_params = {:SiteName => @site.SiteName}
          post :update, {:id => @site.id, :clinical_site => update_params}
          assert_redirected_to clinical_sites_path
          assert_equal assigns(:site), @site
        end

        test "should not post -- bad params" do
          @site.SiteName = nil

          #assemble params
          update_params = {:SiteName => @site.SiteName}

          #post!
          post :update, {:id => @site.id, :clinical_site => update_params}
          assert_response :success
          assert_template 'edit'
          assert_equal "Error updating site.", flash[:notice]
        end

      end
    end
  end

  describe "create" do
    allowed_roles.each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
          @site = FactoryGirl.build :clinical_site
        end

        test "should post" do

          post :create, {:clinical_site => @site.attributes}

          exepcted_attrs = @site.attributes
          actual_attrs = assigns(:site).attributes
          [exepcted_attrs, actual_attrs].map { |i| i.delete("id")}

          assert_equal exepcted_attrs, actual_attrs
          assert_redirected_to clinical_sites_path
          assert_equal flash[:notice], "Created #{assigns(:site).SiteName}."
        end

        test "should not post -- bad params" do
          @site.SiteName = nil
          post :create, {:clinical_site => @site.attributes}

          assert :successs
          assert_equal expected_attrs, actual_attrs
          assert_equal flash[:notice], "Error creating site."
          assert_template "new"
        end

      end
    end
  end


  describe "delete" do
    allowed_roles.each do |r|
      describe "as #{r}" do
        before do
          @site = FactoryGirl.create :clinical_site
        end

        test "should get" do
          get :delete, {:clinical_site_id => @site.id}
          assert_equal @site, assigns(:site)
        end

        test "should not get -- bad id" do
          assert_raise(ActiveRecord::RecordNotFound) {get :delete, {:clinical_site_id => "bad id"}
        end
      end
    end
  end

  test "should destroy site and dependent teachers and assignments" do
    expected_term = BannerTerm.current_term(exact: false, plan_b: :forward)
    role_names.each do |r|
      load_session(r)
      expected_site = FactoryGirl.create :clinical_site

      expected_teacher = FactoryGirl.create :clinical_teacher, {
        :clinical_site_id => expected_site.id
      }

      expected_assign = FactoryGirl.create :clinical_assignment, {
        :clinical_teacher_id => expected_teacher.id,
        :Term => expected_term.id,
        :StartDate => expected_term.StartDate.strftime("%Y/%m/%d"),
        :EndDate => expected_term.EndDate.strftime("%Y/%m/%d")
      }

      post :destroy, {:id => expected_site.id}

      assert_equal(expected_site, assigns(:site))
      assert assigns(:site).destroyed?
      assigns(:site).clinical_teachers.each{|i| assert i.destroyed?}    #should auto delete any teacher assignments when teacher destroyed
      assigns(:site).clinical_teachers.each{|i| i.clinical_assignments.each{|j| assert j.destroyed?}}    #are all assignments destroyed?
      assert_equal flash[:notice], "Deleted Successfully"
      assert_redirected_to(clinical_sites_path)
    end
  end

  test "should not destroy site bad role" do

    (role_names - allowed_roles).each do |r|
      load_session(r)
      expected_site = FactoryGirl.create :clinical_site
      post :destroy, {:id => expected_site.id}
      assert_redirected_to "/access_denied"
    end
  end

end
