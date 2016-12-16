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
            FactoryGirl.create_list :foi, 5
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
      @b = Nokogiri::XML::Builder.new do |xml|
        xml.Responses do
          xml.Response do
            xml.QID2_3 @stu.Bnum
            xml.endDate "2015-01-03 13:45:57"
            xml.QID5 "New Form"
            xml.QID4 Major.first.name
            xml.QID3 "Yes"
            xml.QID6 "Yes"
          end
        end
      end
      @test_file_loc = Rails.root.join('test', 'test_temp', 'test_foi.xml')

    end

    describe "authorized" do
      allowed_roles.each do |r|
        describe "as #{r}" do

          describe "valid data" do

            before do
              File.write(@test_file_loc, @b.to_xml)
              file = Paperclip.fixture_file_upload(@test_file_loc)

              load_session(r)
              post :import, :file => file
            end

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
            doc = Nokogiri::XML(@b.to_xml)
            doc.at_xpath('Responses/Response/QID2_3').content = nil
            File.write(@test_file_loc, doc.to_xml)
            file = Paperclip.fixture_file_upload(@test_file_loc)

            load_session(r)
            post :import, :file => Paperclip.fixture_file_upload(@test_file_loc)

          end

          test "doesn't import record" do
            assert_equal Foi.all.size, @pre_record_count
          end

          test "flash message" do
            expected_message = "Error in record 1: Validation failed: Student could not be identified."
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
            File.write(@test_file_loc, @b.to_xml)
            file = Paperclip.fixture_file_upload(@test_file_loc)

            load_session(r)
            post :import, :file => file
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
