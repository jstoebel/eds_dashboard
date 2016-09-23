# == Schema Information
#
# Table name: adm_st
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  BannerTerm_BannerTerm :integer
#  Attempt               :integer
#  OverallGPA            :float(24)
#  CoreGPA               :float(24)
#  STAdmitted            :boolean
#  STAdmitDate           :datetime
#  STTerm                :integer
#  Notes                 :text(65535)
#  background_check      :boolean
#  beh_train             :boolean
#  conf_train            :boolean
#  kfets_in              :boolean
#  created_at            :datetime
#  updated_at            :datetime
#  student_file_id       :integer
#

require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess
class AdmStTest < ActiveSupport::TestCase

	describe "basic validations" do

		before do
			@app = AdmSt.new
			@app.valid?
		end

		test "student_id" do
			assert_equal ["No student selected."], @app.errors[:student_id]
		end

		test "BannerTerm_BannerTerm" do
			assert_equal ["No term could be determined."], @app.errors[:BannerTerm_BannerTerm]
		end

		test "BannerTerm_BannerTerm" do
			assert_equal ["No term could be determined."], @app.errors[:BannerTerm_BannerTerm]
		end

		test "student_file is ok" do
			assert_equal [], @app.errors[:student_file_id]
		end

		test "admit date is ok" do
			assert_equal [], @app.errors[:STAdmitDate]
		end

		test "admitted is ok" do
			assert_equal [], @app.errors[:STAdmitted]
		end

		describe "with admitted" do

			before do
				@app.STAdmitted = true
				@app.valid?
			end

			test "student_file" do
				assert_equal ["Please attach an admission letter."], @app.errors[:student_file_id]
			end

			test "admit date" do
				assert_equal ["Admission date must be given."], @app.errors[:STAdmitDate]
			end
		end # with admitted

		test "admit date but no decision" do
			@app.STAdmitDate = Date.today
			@app.valid?
			assert_equal ["Please make an admission decision for this student."], @app.errors[:STAdmitted]
		end

	end

	describe "complex validations" do

		before do
			@stu = FactoryGirl.create :admitted_student
			@app = FactoryGirl.create :adm_st, {:student_id => @stu.id,
				:BannerTerm_BannerTerm => BannerTerm.current_term(:exact => false, :plan_b => :back).id,
				:STAdmitted => nil,
				:STAdmitDate => nil
			}

		end

		test "good_gpa" do
			@app.OverallGPA = 2.75
			@app.CoreGPA = 2.5
			assert @app.good_gpa?
		end

		test "admit too early" do
			@app.STAdmitDate = @app.banner_term.StartDate - 1
			@app.STAdmitted = true
			@app.valid?
			assert_equal ["Admission date must be after term begins."], @app.errors[:STAdmitDate]
		end

		test "admit too late" do
			@app.STAdmitDate = @app.banner_term.next_term.StartDate
			@app.STAdmitted = true
			@app.valid?
			assert_equal ["Admission date may not be after next term begins."], @app.errors[:STAdmitDate]
		end

		describe "can't apply again" do

			before do
				@app2 = FactoryGirl.build :adm_st, {:student_id => @stu.id,
					:BannerTerm_BannerTerm => BannerTerm.current_term(:exact => false, :plan_b => :back).id,
					:STAdmitted => nil,
					:STAdmitDate => nil
				}

			end

			[true, nil].each do |status|
				test "first app: #{status.to_s}" do
					@app.STAdmitted = status
					@app2.valid?
					assert_equal ["Student has already been admitted or has an open applicaiton in this term."], @app2.errors[:base]
				end
			end

		end

	end # complex validations

	test "scope by term" do

		curr_term = BannerTerm.current_term
		expected_apps = AdmSt.by_term(curr_term)
		actual_apps = AdmSt.all.where("BannerTerm_BannerTerm = ?", curr_term)

		assert_equal(expected_apps.slice(0, expected_apps.size), actual_apps.slice(0, actual_apps.size))

	end

end
