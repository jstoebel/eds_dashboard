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
			@app = FactoryGirl.build :pending_adm_st, {:student_id => @stu.id}

		end

		test "good_gpa" do
			@app.OverallGPA = 2.75
			@app.CoreGPA = 2.5
			assert @app.good_gpa?
		end

		test "admit too early" do
			@app.assign_attributes({:STAdmitDate => @app.banner_term.StartDate - 1,
				:STAdmitted => true})
			@app.valid?
			assert_equal ["Admission date must be after term begins."], @app.errors[:STAdmitDate]
		end

		test "admit too late" do
			next_term = FactoryGirl.create :banner_term, {:StartDate => @app.banner_term.EndDate + 10,
				:EndDate => @app.banner_term.EndDate + 20
			}

			@app.assign_attributes({:STAdmitDate => next_term.StartDate,
				:STAdmitted => true})
			@app.valid?
			assert_equal ["Admission date may not be after next term begins."], @app.errors[:STAdmitDate]
		end

	end # complex validations

	describe "two apps" do

		describe "first app: denied" do
			before do
				first_app = FactoryGirl.create :denied_adm_st
				@stu = first_app.student
			end # before

			[:pending, :accepted, :denied].each do |second_status|
				test "second app: #{second_status}" do
					second_app = FactoryGirl.build "#{second_status}_adm_st", {:student => @stu}
					assert second_app.valid?, second_app.errors.full_messages
				end # test
			end # status loop
		end # first app: denied

		[:pending, :accepted].each do |first_app_status|
			describe "first app: #{first_app_status}" do
				before do
					@first_app = FactoryGirl.create "#{first_app_status}_adm_st"
					@stu = @first_app.student
				end # before

				[:pending, :accepted, :denied].each do |second_status|
					test "second app: #{second_status}" do

						second_app = FactoryGirl.build "#{second_status}_adm_st", {:student => @stu,
							:banner_term => @first_app.banner_term
						}
						assert_not second_app.valid?, second_app.inspect
					end # test

					test "second app: #{second_status} with different term" do

						second_app = FactoryGirl.build "#{second_status}_adm_st", {:student => @stu
						}
						assert second_app.valid?, second_app.inspect
					end # test
				end # status loop

			end # inner describe
		end # first app loop


	end

	test "scope by term" do

		curr_term = BannerTerm.current_term
		expected_apps = AdmSt.by_term(curr_term)
		actual_apps = AdmSt.all.where("BannerTerm_BannerTerm = ?", curr_term)

		assert_equal(expected_apps.slice(0, expected_apps.size), actual_apps.slice(0, actual_apps.size))

	end

end
