require 'test_helper'
require 'test_teardown'

class Api::StudentsControllerTest < ActionController::TestCase


	describe "index" do
		it "returns all students" do
			get :api_index
			expect assigns(:students).must_equal Student.all
		end

		it "responds 200" do

		end
	end

	describe "show" do
		it "returns the student" do
		end

		it "responds 200" do
		end
	end

	describe "create" do
		it "batch creates records" do
		end

		it "returns 200" do
		end

		it "does not batch create" do
		end

		it "returns 422" do
		end
	end

	describe "update" do
		it "updates the record" do
		end

		it "swaps PrevLast" do
		end

		it "returns 200" do
		end

		it "detects droping eds major" do
		end

		it "detects droping cert concentration" do
		end

	end

end