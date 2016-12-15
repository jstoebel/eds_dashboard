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
class FoiTest < ActiveSupport::TestCase


  describe "basic validations" do

    before do
      @foi = Foi.new
      @foi.valid?
    end


    test "student_id" do
      assert_equal ["could not be identified."], @foi.errors[:student_id]
    end

    test "date_completing" do
      assert_equal ["is missing or incorrectly formatted. Example format: 01/01/16 13:00:00"], @foi.errors[:date_completing]
    end

    test "new_form" do
      assert_equal ["Can't determine if this is a new form."], @foi.errors[:new_form]
    end

    test "seek_cert" do
      assert_equal ["Could not determine if student is seeking certification."], @foi.errors[:seek_cert]
    end

    describe "conditional validations" do

      test "major_id" do
        @foi.seek_cert = true
        @foi.valid?

        assert_equal ["is required and could not be determined."], @foi.errors[:major_id]
        assert_equal [], @foi.errors[:eds_only]
      end

      test "eds_only" do
        @foi.seek_cert = false
        @foi.valid?

        assert_equal ["Could not determine if student is seeking EDS only"], @foi.errors[:eds_only]
        assert_equal [], @foi.errors[:major_id]
      end

    end

  end

  describe "_import_row" do
    before do
      @stu = FactoryGirl.create :student
      @row = {"QID2_3" => @stu.Bnum,
        "endDate" => DateTime.now.strftime("%m/%d/%y %k:%M:%S"),
        "QID5" => "New Form",
        "QID4" => Major.first.name,
        "QID3" => "Yes",
        "QID6" => "Yes"
      }
    end

    describe "successful import" do

      describe "response combinations" do
        describe "new form" do
          before do
            @key = "QID5"
          end

          test "New Form" do
            @row[@key] = "New Form"
            assert_difference("Foi.count", 1) do
              Foi._import_foi(@row)
            end
          end

          test "Revision" do
            @row[@key] = "Revision"
            assert_difference("Foi.count", 1) do
              Foi._import_foi(@row)
            end
          end

          test "Spam" do
            @row[@key] = "Spam"
            assert_raises(ActiveRecord::RecordInvalid) do
              Foi._import_foi(@row)
            end
          end

          test "nil" do
            @row[@key] = nil
            assert_raises(ActiveRecord::RecordInvalid) do
              Foi._import_foi(@row)
            end
          end

        end # describe new form

        describe "seek_cert" do
          before do
            @key = "QID3"
          end

          test "Yes" do
            @row[@key] = "Yes"
            assert_difference("Foi.count", 1) do
              Foi._import_foi(@row)
            end
          end

          test "No" do
            @row[@key] = "No"
            assert_difference("Foi.count", 1) do
              Foi._import_foi(@row)
            end
          end

          test "Spam" do
            @row[@key] = "Spam"
            assert_raises(ActiveRecord::RecordInvalid) do
              Foi._import_foi(@row)
            end
          end

          test "nil" do
            @row[@key] = nil
            assert_raises(ActiveRecord::RecordInvalid) do
              Foi._import_foi(@row)
            end
          end

        end # seek _cert

        describe "eds_only" do
          before do
            # need seek_cert false to throw the error
            @row["QID3"] = "No"
            @key = "QID6"
          end

          test "Yes" do
            @row[@key] = "Yes"
            assert_difference("Foi.count", 1) do
              Foi._import_foi(@row)
            end
          end

          test "No" do
            @row[@key] = "No"
            assert_difference("Foi.count", 1) do
              Foi._import_foi(@row)
            end
          end

          test "Spam" do
            @row[@key] = "Spam"
            assert_raises(ActiveRecord::RecordInvalid) do
              Foi._import_foi(@row)
            end
          end

          test "nil" do
            @row[@key] = nil
            assert_raises(ActiveRecord::RecordInvalid) do
              Foi._import_foi(@row)
            end
          end

        end # seek _cert

      end

      test "imports row" do
        assert_difference('Foi.count', 1) do
          Foi._import_foi(@row)
        end
      end

      test "foi matches student" do
        Foi._import_foi(@row)
        assert_equal 1, @stu.foi.size
      end

      test "seek_cert and no major given" do
        @row["QID4"] = nil
        assert_difference('Foi.count', 1) do
          Foi._import_foi(@row)
        end
      end

    end # successful import

    test "doesn't import row - missing param" do
      @row["QID2_3"] = nil
      assert_raises ActiveRecord::RecordInvalid do
        Foi._import_foi(@row)
      end
    end


  end # outer describe

  describe "import" do

    before do
      FileUtils.mkdir(Rails.root.join('test', 'test_temp'))
      @stu = FactoryGirl.create :student
      @test_file_loc = Rails.root.join('test', 'test_temp', 'test_foi.xml')
    end

    describe "successful import" do

      before do
        # create the xml doc
        b = Nokogiri::XML::Builder.new do |xml|
          xml.Responses do
            xml.Response do
              xml.QID2_3 @stu.Bnum
              xml.endDate "01/01/16 13:00:00"
              xml.QID5 "New Form"
              xml.QID4 Major.first.name
              xml.QID3 "Yes"
              xml.QID6 "Yes"
            end
          end
        end

        File.write(@test_file_loc, b.to_xml)
      end # before

      test "creates a FOI" do
        assert_difference("Foi.count", 1) do
          Foi.import(Paperclip.fixture_file_upload(@test_file_loc))
        end
      end

      test "Foi matches student" do
        result = Foi.import(Paperclip.fixture_file_upload(@test_file_loc))
        assert_equal 1, @stu.foi.size, result.inspect
      end

    end

    describe "unsuccessful import bad params" do
      # make a spreadsheet with two rows: one good, one broken
      # neither should be created
      # return {success: false, message: "Error on line #{row_num}: #{e.message}"}
      # test params of the above hash

      before do
        @second_stu = FactoryGirl.create :student
        b = Nokogiri::XML::Builder.new do |xml|

          xml.Responses do
            # good record
            xml.Response do
              xml.QID2_3 @stu.Bnum
              xml.endDate "01/01/16 13:00:00"
              xml.QID5 "New Form"
              xml.QID4 Major.first.name
              xml.QID3 "Yes"
              xml.QID6 "Yes"
            end

            # bad record
            xml.Response do
              xml.QID2_3 nil
              xml.endDate "01/01/16 13:00:00"
              xml.QID5 "New Form"
              xml.QID4 Major.first.name
              xml.QID3 "Yes"
              xml.QID6 "Yes"
            end
          end # root
        end # new builder
        File.write(@test_file_loc, b.to_xml)
      end # before

      test "Multiple Entries - One student with bad params, one with good params" do

        assert_no_difference 'Foi.count' do
          err = assert_raises(RuntimeError) {Foi.import(Paperclip.fixture_file_upload(@test_file_loc))}
          assert_equal "Error in record 2: Validation failed: Student could not be identified.", err.message
        end

      end

    end
  end
end
