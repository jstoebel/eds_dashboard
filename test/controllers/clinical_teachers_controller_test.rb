# == Schema Information
#
# Table name: clinical_teachers
#
#  id               :integer          not null, primary key
#  Bnum             :string(45)
#  FirstName        :string(45)       not null
#  LastName         :string(45)       not null
#  Email            :string(45)
#  Subject          :string(45)
#  clinical_site_id :integer          not null
#  Rank             :integer
#  YearsExp         :integer
#

require 'test_helper'

class ClinicalTeachersControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "advisor", "staff", "student labor"]

  def assert_form_details
        py_assert assigns(:sites), ClinicalSite.all
        py_assert assigns(:subjects), Program.where(Current: true)
  end

  test "should get index" do

    allowed_roles.each do |r|
      load_session(r)
      get :index
      assert_response :success
      py_assert assigns(:teachers), ClinicalTeacher.all
    end
  end

  # test "should get show" do
  #   get :show
  #   assert_response :success
  # end

  test "should get edit" do
    allowed_roles.each do |r|
      load_session(r)
      teacher = ClinicalTeacher.first
      get :edit, :id => teacher.id
      assert_response :success
      assert_form_details
      py_assert assigns(:teacher), teacher
    end
  end

  test "should get update" do
    allowed_roles.each do |r|
      load_session(r)
      teacher = ClinicalTeacher.first
      teacher.FirstName = "new first name"

      update_params = {:FirstName => teacher.FirstName}

      #post!
      post :update, {:id => teacher.id, :clinical_teacher => update_params}
      assert_redirected_to clinical_teachers_path
      py_assert assigns(:teacher), teacher
      py_assert flash[:notice], "Updated Teacher #{teacher.FirstName} #{teacher.LastName}."
    end
  end

  test "should not post update bad record" do
    #test what happens when the record can't be saved

    load_session("admin")
    teacher = ClinicalTeacher.first
    teacher.FirstName = nil

    update_params = {:FirstName => teacher.FirstName}

    #post!
    post :update, {:id => teacher.id, :clinical_teacher => update_params}
    assert_response :success
    assert_template 'edit'
    assert_form_details
  end

  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert_form_details
    end
  end

  test "should post create" do
    allowed_roles.each do |r|

      load_session(r)
    
      site = ClinicalSite.first

      new_params = {
        :Bnum => "B00123456",
        :FirstName => "test first",
        :LastName => "test last",
        :Email => "test@email.com",
        :Subject => "test subject",
        :clinical_site_id => site.id,
        :Rank => "3",
        :YearsExp => "1"
      }

      post :create, {:clinical_teacher => new_params}
      assert_redirected_to clinical_teachers_path

      expected_teacher = ClinicalTeacher.create(new_params)
      actual_teacher = assigns(:teacher)

      py_assert flash[:notice], "Created new teacher #{expected_teacher.FirstName} #{expected_teacher.LastName}."

    end
  end

test "should not post create bad params" do

    load_session("admin")
  
    site = ClinicalSite.first

    new_params = {
      :Bnum => "bad bnum!",
      :FirstName => "test first",
      :LastName => "test last",
      :Email => "test@email.com",
      :Subject => "test subject",
      :clinical_site_id => site.id,
      :Rank => "3",
      :YearsExp => "1"
    }

    post :create, {:clinical_teacher => new_params}
    assert_response :success
    assert_form_details
    assert_template 'new'

  end

end
