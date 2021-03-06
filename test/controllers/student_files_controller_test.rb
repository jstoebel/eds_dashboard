# == Schema Information
#
# Table name: student_files
#
#  student_id       :integer          not null
#  id               :integer          not null, primary key
#  active           :boolean          default(TRUE)
#  doc_file_name    :string(100)
#  doc_content_type :string(100)
#  doc_file_size    :integer
#  doc_updated_at   :datetime
#

require 'test_helper'
#advisors and staff can :manage
#student labor can [:index, :new, :create, :delete, :destroy]

#help on tests with paperclip: http://blog.joncairns.com/2012/11/uploading-files-in-functional-tests-with-rails-paperclip-and-test-unit/

class StudentFilesControllerTest < ActionController::TestCase

  test "should get index" do
    #create a file and test that its there

    file = FactoryGirl.create :student_file

    assert file.errors.empty?, file.inspect
    stu = file.student

    role_names.each do |r|
      load_session(r)

      get :index, params: {:student_id => stu.AltID}

      test_index_setup(stu)
      assert_response :success

    end
  end

  test "should post create" do
    role_names.each do |r|
      StudentFile.delete_all  #clear out the files to avoid duplicates
      load_session(r)
      stu = FactoryGirl.create :student


      expected_stu_file = StudentFile.new(
        :student_id => stu.id,
        :active => true)
      expected_stu_file.doc = fixture_file_upload 'test_file.txt'

      post :create, params: {:student_id => stu.AltID,
        :active => true,
        :student_file =>
          {:doc => fixture_file_upload('test_file.txt')}
      }

      assert assigns(:file).errors.blank?, assigns(:file).errors.full_messages
      assert_redirected_to student_student_files_path(stu.AltID)
      assert_equal "File successfully uploaded.", flash[:info]

      #are the records the same except for their id?
      expected_attrs = expected_stu_file.attributes
      actual_attrs = assigns(:file).attributes
      [expected_attrs, actual_attrs].map { |i| i.except!("id", "doc_updated_at")}
      assert_equal expected_attrs.inspect, actual_attrs.inspect
    end

  end

  test "should not post create bad params" do
    #create this record so the test requested post will not result in a
    #successful save

    file = FactoryGirl.create :student_file
    role_names.each do |r|
      load_session(r)
      stu = Student.first

      post :create, params: {:student_id => stu.AltID,
        :active => true,
        :student_file =>
          {:doc => fixture_file_upload('badfile.bad')}
      }

      assert_response :success
      assert_equal "Error uploading file.", flash[:info]
      assert_template :index
    end

  end

  test "should post destroy" do

    role_names.each do |r|
      load_session(r)
      StudentFile.delete_all
      file = FactoryGirl.create :student_file
      post :destroy, params: {:id => file.id}

      assert_equal file, assigns(:file)
      puts assigns(:file).errors.full_messages
      assert_equal "File successfully removed.", flash[:info]

      assert_redirected_to student_student_files_path(file.student.AltID)
    end
  end

  # TODO test for download
  # test "should get download" do
  #   role_names.each do |r|
  #     load_session(r)
  #     get :download
  #   end
  # end

  ##TESTS FOR UNAUTHORIZED USERS

  test "should not get download bad role" do
    bad_roles = ["student labor"]
    bad_roles.each do |r|
      load_session(r)
      get :download, params: {:student_file_id => "who cares"}
      assert_redirected_to "/access_denied"
    end
  end


  private
  def test_index_setup(stu)
    assert_equal stu.attributes, assigns(:student).attributes
    user = User.find_by(:UserName => session[:user])
    ability = Ability.new(user)
    assert_equal stu.student_files.active.select {|r| ability.can? :read, r }.to_a, assigns(:docs).to_a
  end

end
