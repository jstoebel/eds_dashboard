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

  test "should get index" do
    role_names.each do |r|
      load_session(r)
      get :index
      assert_response :success
      assert_equal assigns(:sites), ClinicalSite.all
    end
  end

  test "should get edit" do
    role_names.each do |r|
      load_session(r)
      site = ClinicalSite.first
      get :edit, {:id => site.id}
      assert_response :success
      assert_equal site, assigns(:site)
    end
  end

  test "should post update" do
    role_names.each do |r|
      load_session(r)
      site = ClinicalSite.first
      #change params of site
      site.SiteName = "changed!"

      #assemble params
      update_params = {:SiteName => site.SiteName}

      #post!
      post :update, {:id => site.id, :clinical_site => update_params}
      assert_redirected_to clinical_sites_path
      assert_equal assigns(:site), site
    end
  end

  test "should not post update bad record" do
    #test what happens when the record can't be saved

    load_session("admin")
    site = ClinicalSite.first
    #change params of site
    site.SiteName = nil

    #assemble params
    update_params = {:SiteName => site.SiteName}

    #post!
    post :update, {:id => site.id, :clinical_site => update_params}
    assert_response :success
    assert_template 'edit'
    assert_equal "Error updating site.", flash[:notice]
  end

  test "should get new" do
    role_names.each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:site).new_record? and not assigns(:site).changed?
    end
  end

  test "should post create" do
    role_names.each do |r|
      #assemble params for a site
      load_session(r)

      new_params = {
        :SiteName => "Test school",
        :City => "test city",
        :County => "county",
        :Principal => "mr. test",
        :District => "district",
        :email => "secretary@school.com",
        :website => "http://www.school.com",
        :receptionist => "Ima Secretary",
        :phone => "(859) 123-4567"
      }


      post :create, {:clinical_site => new_params}

      expected_site = ClinicalSite.create(new_params)
      actual_site = assigns(:site)
      assert_redirected_to clinical_sites_path
      exepcted_attrs = expected_site.attributes
      actual_attrs = assigns(:site).attributes

      [exepcted_attrs, actual_attrs].map { |i| i.delete("id")}

      assert_equal exepcted_attrs, actual_attrs

      assert_equal flash[:notice], "Created #{assigns(:site).SiteName}."

    end
  end

  test "should not post create bad record" do
    load_session("admin")

    new_params = {
      :City => "test city",
      :County => "county",
      :Principal => "mr. test",
      :District => "district"
    } #no SiteName!
    expected_site = ClinicalSite.new(new_params)

    post :create, {:clinical_site => new_params}

    assert_response :success

    expected_attrs = expected_site.attributes
    actual_attrs =  assigns(:site).attributes

    [expected_attrs, actual_attrs].map {|i| i.delete(:id)}

    assert_equal expected_attrs, actual_attrs
    assert_equal flash[:notice], "Error creating site."
    assert_template "new"
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

  test "should allow delete" do
    allowed_roles.each do |r|
      load_session(r)
      expected_site = FactoryGirl.create :clinical_site
      get :delete, {:clinical_site_id => expected_site.id}
      assert_equal expected_site, assigns(:site)
    end
  end

  test "should not allow delete bad role" do
    expected_site = FactoryGirl.create :clinical_site
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :delete, {:id => expected_site.id}
      assert_redirected_to "/access_denied"
    end
  end
end
