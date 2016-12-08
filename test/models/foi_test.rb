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
      assert_equal ["Student could not be identified."], @foi.errors[:student_id]
    end

    test "date_completing" do
      assert_equal ["Date completing is missing or incorrectly formatted. Example format: 01/01/16 13:00"], @foi.errors[:date_completing]
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
      @row = {"Please tell us about yourself-B#" => @stu.Bnum,
        "EndDate" => Date.today.strftime("%m/%d/%y %k:%M"),
        "Are you completing this form for the first time, or is this form a / revision?" => "New Form",
        "Which area do you wish to seek certification in?" => Major.first.name,
        "Do you intend to seek teacher certification at Berea College?" => "Yes",
        "Do you intend to seek an Education Studies degree without certification?" => "Yes"
      }
    end

    describe "successful import" do

      describe "response combinations" do
        describe "new form" do
          before do
            @key = "Are you completing this form for the first time, or is this form a / revision?"
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
            @key = "Do you intend to seek teacher certification at Berea College?"
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
            @row["Do you intend to seek teacher certification at Berea College?"] = "No"
            @key = "Do you intend to seek an Education Studies degree without certification?"
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
        @row["Which area do you wish to seek certification in?"] = nil
        assert_difference('Foi.count', 1) do
          Foi._import_foi(@row)
        end
      end

    end # successful import

    test "doesn't import row - missing param" do
      @row["Please tell us about yourself-B#"] = nil
      assert_raises ActiveRecord::RecordInvalid do
        Foi._import_foi(@row)
      end
    end


  end # outer describe

  describe "import" do

    before do
      FileUtils.mkdir(Rails.root.join('test', 'test_temp'))
    end

    describe "successful import" do

      before do
        # create the CSV fi-temple

        @stu = FactoryGirl.create :student
        @expected_attrs = {"Please tell us about yourself-B#" => @stu.Bnum,
          "EndDate" => Date.today.strftime("%m/%d/%y %k:%M"),
          "Are you completing this form for the first time, or is this form a / revision?" => "New Form",
          "Which area do you wish to seek certification in?" => Major.first.name,
          "Do you intend to seek teacher certification at Berea College?" => "Yes",
          "Do you intend to seek an Education Studies degree without certification?" => "Yes"
        }

        headers = @expected_attrs.keys
        @test_file_loc = Rails.root.join('test', 'test_temp', 'test_foi.csv')


        CSV.open(@test_file_loc, "w") do |csv|
          csv << []  #first row or "super headers"
          csv << headers
          csv << @expected_attrs.values
        end
      end # before

      test "creates a FOI" do
        assert_difference("Foi.count", 1) do
          Foi.import(Paperclip.fixture_file_upload(@test_file_loc)) # change this to Foi.import(Paperclip.fixture_file_upload(@test_file_loc)
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
        @stu = FactoryGirl.create :student
        @expected_attrs = {"Please tell us about yourself-B#" => nil,
          "EndDate" => Date.today.strftime("%m/%d/%y %k:%M"),
          "Are you completing this form for the first time, or is this form a / revision?" => "new form",
          "Which area do you wish to seek certification in?" => Major.first.name,
          "Do you intend to seek teacher certification at Berea College?" => "yes",
          "Do you intend to seek an Education Studies degree without certification?" => "yes"
        }
        @second_stu = FactoryGirl.create :student
        @second_expected_attrs = {"Please tell us about yourself-B#" => @second_stu.Bnum,
          "EndDate" => Date.today.strftime("%m/%d/%y %k:%M"),
          "Are you completing this form for the first time, or is this form a / revision?" => "bad param",
          "Which area do you wish to seek certification in?" => Major.first.name,
          "Do you intend to seek teacher certification at Berea College?" => "yes",
          "Do you intend to seek an Education Studies degree without certification?" => "yes"
        }


        headers = @expected_attrs.keys
        second_header = @second_expected_attrs.keys
        @test_file_loc = Rails.root.join('test', 'test_temp', 'test_foi.csv')

        CSV.open(@test_file_loc, "w") do |csv|
          csv << []  #first row or "super headers"
          csv << @expected_attrs.keys
          csv << @expected_attrs.values
          csv << @second_expected_attrs.values
        end
      end # before

      test "Multiple Entries - One student with bad params, one with good params" do
        before_count = Foi.count
        begin
          Foi.import(Paperclip.fixture_file_upload(@test_file_loc))
        rescue
          assert_equal Foi.count, before_count
        end

      end

    end
  end
end
