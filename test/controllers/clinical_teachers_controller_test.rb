# == Schema Information
#
# Table name: clinical_teachers
#
#  id                  :integer          not null, primary key
#  Bnum                :string(45)
#  FirstName           :string(45)       not null
#  LastName            :string(45)       not null
#  Email               :string(45)
#  Subject             :string(45)
#  clinical_site_id    :integer          not null
#  Rank                :integer
#  YearsExp            :integer
#  begin_service       :datetime
#  epsb_training       :datetime
#  ct_record           :datetime
#  co_teacher_training :datetime
#

require 'test_helper'
class ClinicalTeachersControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor", "staff", "student labor"]

  def assert_form_details
        assert_equal assigns(:sites).to_a, ClinicalSite.all.to_a
        assert_equal assigns(:subjects).to_a, Program.where(Current: true).order(:EDSProgName).to_a
  end

  test "should get index" do

    allowed_roles.each do |r|
      load_session(r)
      get :index
      assert_response :success
      assert_equal assigns(:teachers), ClinicalTeacher.all
    end
  end

  test "should get edit" do
    allowed_roles.each do |r|
      load_session(r)
      teacher = FactoryGirl.create :clinical_teacher
      get :edit, :id => teacher.id
      assert_response :success
      assert_form_details
      assert_equal assigns(:teacher), teacher
    end
  end

  test "should post update" do
    allowed_roles.each do |r|
      load_session(r)
      teacher = FactoryGirl.create :clinical_teacher

      update_params = {:FirstName => "new name"}
      teacher.assign_attributes update_params

      #post!
      post :update, {:id => teacher.id, :clinical_teacher => update_params}
      assert_redirected_to clinical_teachers_path
      assert_equal assigns(:teacher), teacher
      assert_equal flash[:notice], "Updated Teacher #{assigns(:teacher).FirstName} #{assigns(:teacher).LastName}."
    end
  end

  test "should not post update bad record" do
    #test what happens when the record can't be saved

    load_session("admin")
    teacher = FactoryGirl.create :clinical_teacher
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

      site = FactoryGirl.create :clinical_site
      new_params = FactoryGirl.attributes_for :clinical_teacher, :clinical_site_id => site.id

      post :create, {:clinical_teacher => new_params}
      assert assigns(:teacher).valid?, assigns(:teacher).errors.full_messages
      assert_redirected_to clinical_teachers_path
      expected_teacher = ClinicalTeacher.create(new_params)

      actual_teacher = assigns(:teacher)
      assert_equal actual_teacher.attributes.delete(:id), expected_teacher.attributes.delete(:id)
      assert_equal flash[:notice], "Created new teacher #{expected_teacher.FirstName} #{expected_teacher.LastName}."

    end
  end

test "should not post create bad params" do

    load_session("admin")

    site = FactoryGirl.create :clinical_site
    new_params = FactoryGirl.attributes_for :clinical_teacher # Won't make an attribute for clinical site and will fail

    post :create, {:clinical_teacher => new_params}
    assert_response :success
    assert_form_details
    assert_template 'new'

  end

test "should delete teacher and dependent assignments" do
  expected_term = BannerTerm.current_term(exact: false, plan_b: :forward)

  allowed_roles.each do |r|
    load_session(r)
    teach = FactoryGirl.create :clinical_teacher
    expected_assign = FactoryGirl.create :clinical_assignment, {
        :clinical_teacher_id => teach.id,
        :Term => expected_term.id,
        :StartDate => expected_term.StartDate.strftime("%Y/%m/%d"),
        :EndDate => expected_term.EndDate.strftime("%Y/%m/%d")
      }

    post :destroy, {:id => teach.id}

    assert_equal(teach, assigns(:teacher))
    assert assigns(:teacher).destroyed?
    assigns(:teacher).clinical_assignments.each{|i| assert i.destroyed?}
    assert_equal flash[:notice], "Deleted Successfully!"
    assert_redirected_to(clinical_teachers_path)
   end
  end

  test "deletion for bad role" do
    (role_names - allowed_roles).each do |r|
    teach = FactoryGirl.create :clinical_teacher
      post :destroy, {:id => teach.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "should allow delete" do
    #teach = FactoryGirl.create :clinical_teacher
    allowed_roles.each do |r|
      load_session(r)
      teach = FactoryGirl.create :clinical_teacher
      get :delete, {:clinical_teacher_id => teach.id}
      assert_equal teach, assigns(:teacher)
    end
  end

  test "should not allow delete bad role" do
    teach=FactoryGirl.create :clinical_teacher
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :delete, {:id => teach.id}
      assert_redirected_to "/access_denied"
    end
  end

end
