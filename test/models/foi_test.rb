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
      assert_equal ["Date completing is missing or incorrectly formatted. Example format: 01/01/2016 09:00:00 AM"], @foi.errors[:date_completing]
    end

    test "new_form" do
      assert_equal ["Can't determine if this is a new form."], @foi.errors[:new_form]
    end

    test "major_id" do
      assert_equal ["Major could not be determined."], @foi.errors[:major_id]
    end

    test "seek_cert" do
      assert_equal ["Could not determine if student is seeking certification."], @foi.errors[:seek_cert]
    end

    test "eds_only" do
      assert_equal ["Could not determine if student is seeking EDS only."], @foi.errors[:eds_only]
    end

  end

  describe "_import_foi" do
    before do
      @stu = FactoryGirl.create :student
      @row = {"Q1.2_3 - B#" => @stu.Bnum ,
        "Recorded Date" => Date.today.strftime("%m/%d/%Y %I:%M:%S %p"),
        "Q1.3 - Are you completing this form for the first time, or is this form a revision..." => "new form",
        "Q3.1 - Which area do you wish to seek certification in?" => Major.first.name,
        "Q1.4 - Do you intend to seek teacher certification at Berea College?" => "yes",
        "Q2.1 - Do you intend to seek an Education Studies degree without certification?" => "yes"
      }
    end

    describe "successful import" do

      test "imports row" do
        assert_difference('Foi.count', 1) do
          Foi._import_foi(@row)
        end
      end

      test "foi matches student" do
        Foi._import_foi(@row)
        assert_equal 1, @stu.foi.size
      end
    end

    describe "doesn't import row - missing param" do

      must_have = ["Q1.2_3 - B#",
        "Recorded Date",
        "Q3.1 - Which area do you wish to seek certification in?",
        "Q1.4 - Do you intend to seek teacher certification at Berea College?",
        "Q2.1 - Do you intend to seek an Education Studies degree without certification?"
         ]

      must_have.each do |k|

        test "missing #{k}" do
            @row[k] = nil

            # should throw an error
            assert_raises ActiveRecord::RecordInvalid do
              Foi._import_foi(@row)
            end
          end

      end # loop

    end #inner describe

  end # outer describe

  describe "import" do

    before do
      FileUtils.mkdir Rails.root.join('test', 'test_temp')
    end

    describe "successful import" do

      before do
        # create the CSV file
        @stu = FactoryGirl.create :student
        @expected_attrs = {"Q1.2_3 - B#" => @stu.Bnum,
          "Recorded Date" => Date.today.strftime("%m/%d/%Y %I:%M:%S %p"),
          "Q1.3 - Are you completing this form for the first time, or is this form a revision..." => "new form",
          "Q3.1 - Which area do you wish to seek certification in?" => Major.first.name,
          "Q1.4 - Do you intend to seek teacher certification at Berea College?" => "yes",
          "Q2.1 - Do you intend to seek an Education Studies degree without certification?" => "yes"
        }

        headers = @expected_attrs.keys
        @test_file_loc = Rails.root.join('test', 'test_temp', 'test_foi.csv')

        CSV.open(@test_file_loc, "w") do |csv|
          csv << []  #first row or "super headers"
          csv << @expected_attrs.keys
          csv << @expected_attrs.values
        end
      end # before

      test "creates a FOI" do
        assert_difference("Foi.count", 1) do
          Foi.import(@test_file_loc)
        end
      end

      test "Foi matches student" do
        result = Foi.import(@test_file_loc)
        assert_equal 1, @stu.foi.size, result.inspect
      end

    end

    describe "unsuccessful import" do
      #TODO
    end

  end

end
