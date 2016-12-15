# == Schema Information
#
# Table name: forms_of_intention
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  date_completing :datetime
#  new_form        :boolean
#  major_id        :integer
#  seek_cert       :boolean
#  eds_only        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class FoisControllerTest < ActionController::TestCase

  all_roles = Role.all.map {|i| i.RoleName}.to_a
  allowed_roles = ["admin", "staff"]

  describe "index" do

    describe "authorized" do
      allowed_roles.each do |r|
        describe "as #{r}" do

          before do
            load_session(r)
            get :index
          end

          test "http success" do
            assert_response :success
          end

          test "pulls records" do
            assert_equal Foi.all.sorted, assigns(:fois)
          end

        end #as #{r}
      end # loop

    end #authorized

    describe "not authorized" do

      (all_roles - allowed_roles).each do |r|
        describe "as #{r}" do

          before do
            load_session(r)
            get :index
          end

          test "redirected" do
            assert_redirected_to "/access_denied"
          end

          test "doesn't pull records" do
            assert assigns(:fois).empty?, assigns(:fois)
          end

        end # as r
      end #loop
    end # not authorized
  end #index

  describe "import" do

    before do
      # create the sheet
      FileUtils.mkdir Rails.root.join('test', 'test_temp')
      @stu = FactoryGirl.create :student
      @pre_record_count = Foi.all.size
      @expected_attrs = {"externalDataReference" => @stu.Bnum,
        "endDate" => Date.today.strftime("%m/%d/%y %k:%M"),
        "QID5" => "New Form",
        "QID4" => Major.first.name,
        "QID3" => "Yes",
        "QID6" => "Yes"
      }

      headers = @expected_attrs.keys
      @test_file_loc = Rails.root.join('test', 'test_temp', 'test_foi.csv')

    end

    describe "authorized" do
      allowed_roles.each do |r|
        describe "as #{r}" do

          before do
            File.open(@test_file_loc, "w") do |file|
              file << []  #first row or "super headers"
              file << @expected_attrs.keys
              file << @expected_attrs.values
            end
            load_session(r)

            file = Paperclip.fixture_file_upload(@test_file_loc)
            post :import, :file => file

          end

          describe "valid data" do
            test "imports record" do
              assert_equal 1, Foi.all.size - @pre_record_count
            end

            test "flash message" do
              num_rows = 1
              assert_equal "#{num_rows} #{"form".pluralize(num_rows) + " of intention"} successfully imported.", flash[:notice]
            end

            test "redirect to index" do
              assert_redirected_to(fois_path)
            end

          end #valid data
        end

        describe "bad data" do
          before do
            @expected_attrs["QID2_3"] = nil # sabatoge record!
            File.open(@test_file_loc, "w") do |file|
              file << []  #first row or "super headers"
              file << @expected_attrs.keys
              file << @expected_attrs.values
            end
            load_session(r)
            post :import, :file => Paperclip.fixture_file_upload(@test_file_loc)

          end

          test "doesn't import record" do
            assert_equal Foi.all.size, @pre_record_count
          end

          test "flash message" do
            expected_message = "Error on line 3: Validation failed: Student Student could not be identified."
            assert_equal expected_message, flash[:notice]
          end

          test "redirect to index" do
            assert_redirected_to(fois_path)
          end

        end # bad data

      end # allowed roles
    end #authorized

    describe "not authorized" do
      (all_roles - allowed_roles).each do |r|
        describe "as #{r}" do

          before do
            File.open(@test_file_loc, "w") do |file|
              file << []  #first row or "super headers"
              file << @expected_attrs.keys
              file << @expected_attrs.values
            end
            load_session(r)
            post :import, :file => Paperclip.fixture_file_upload(@test_file_loc)
          end

          test "doesn't import records" do
            assert_equal Foi.all.size, @pre_record_count
          end

          test "redirect to access_denied" do
            assert_redirected_to  "/access_denied"
          end

        end # as r
      end # loop
    end # not authorized

  end
end
