require 'test_helper'

class ClinicalSitesControllerTest < ActionController::TestCase
  #all roles have access to this resource
  test "should get index" do
    role_names.each do |r|
      load_session(r)
      get :index
      assert_response :success
      py_assert assigns(:sites), ClinicalSite.all
    end
  end

  test "should get edit" do
    role_names.each do |r|
      load_session(r)
      site = ClinicalSite.first
      get :edit, {:id => site.id}
      assert_response :success
      py_assert site, assigns(:site)
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
      py_assert assigns(:site), site
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
        :District => "district"
      }


      post :create, {:clinical_site => new_params}

      expected_site = ClinicalSite.create(new_params)
      actual_site = assigns(:site)

      assert_redirected_to clinical_sites_path
      py_assert expected_site.attributes.delete(:id), assigns(:site).attributes.delete(:id) #attibute hashes should be equal except for the id
      py_assert flash[:notice], "Created #{assigns(:site).SiteName}."

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
    py_assert expected_site.attributes.delete(:id), assigns(:site).attributes.delete(:id) #attibute hashes should be equal except for the id
    py_assert flash[:notice], "Error creating site."
    assert_template "new"

  end

end
