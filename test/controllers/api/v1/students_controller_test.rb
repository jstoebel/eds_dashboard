require 'test_helper'
require 'test_teardown'

class StudentsControllerTest < ActionController::TestCase

  before do
  	@controller = Api::V1::StudentsController.new
  end

	describe "index" do

		before do
			get :index, format: :json
		end

		it "responds with all students" do
			expected_students = Student.all.map{|s| }
			body =  JSON.parse(response.body)
			expect body.must_equal Student.all.as_json
		end

		it "responds 200" do
			assert_response :success 
		end
	end


	describe "show" do
		before do
			@s = FactoryGirl.create :student
			get :show, {:id => @s.id, format: :json}
		end

		it "responds with the student" do
			body = JSON.parse(response.body)
			expect body.must_equal Student.find(@s.id).as_json
		end

		it "responds 200" do
			assert_response :success 
		end
	end

	#to be used by both create and update


	describe "create" do
		let(:stus){2.times.map{|i| FactoryGirl.attributes_for :student}}

		before do
			@before_count = Student.all.size
			post :batch_create, {format: :json, :students => stus}
		end

		it "batch creates records" do
			expect (Student.all.size).must_equal @before_count + stus.size
		end

		it "returns 200" do
			assert_response :created
		end

		it "returns success message" do
			resp = JSON.parse(response.body)
			expect (resp["msg"]).must_equal "Successfully inserted #{stus.size} records."
		end

		it "does not batch create" do
			@controller = Api::V1::StudentsController.new 	# you need to explicitly specify the controller
			post :batch_create, {format: :json, :students => stus} 	#resubmit the same data
			resp = JSON.parse(response.body)
			expect resp["msg"].must_equal "Validation failed: Bnum has already been taken"
		end

		it "returns 422" do
			@controller = Api::V1::StudentsController.new 	# you need to explicitly specify the controller
			post :batch_create, {format: :json, :students => stus} 	#resubmit the same data
			assert_response :unprocessable_entity		
		end
	end

	describe "updates successfully" do

		before do
			@controller = Api::V1::StudentsController.new
			@two_stus = Student.all.slice(0,2)
			update_params = {:CurrentMajor1 => "New Major!"}
			stu_attrs = @two_stus.map{|s| s.attributes.merge(update_params)}
			patch :batch_update, {format: :json, :students => stu_attrs}
		end

		it "updates the records" do
			@two_stus.each do |s|
				stu = Student.find s.id
				expect stu.CurrentMajor1.must_equal "New Major!"
			end
		end

		it "returns ok" do
			assert_response :ok
		end

	end

	describe "fails to update" do

		before do
			@two_stus = Student.all.slice(0,2)
			update_params = {:EnrollmentStatus => nil}
			stu_attrs = @two_stus.map{|s| s.attributes.merge(update_params)}
			patch :batch_update, {format: :json, :students => stu_attrs}
			@resp = JSON.parse(response.body)
		end


		it "doesn't update record" do
			expect @resp["success"].must_equal false
		end

		it "returns unprocessable_entity" do
			assert_response :unprocessable_entity
		end

	end

end