require 'test_helper'
require 'test_teardown'

class PraxisResultsControllerTest < ActionController::TestCase

  before do
    @controller = Api::V1::PraxisResultsController.new
  end

  describe "successful upsert" do

    let(:stu){Student.first}
    let(:test){PraxisTest.first}
    let(:post_params){{"bnum" : "B00000001",
        "praxis_result" : {
            "TestCode": "5439",
            "test_date" : "2016-06-22",
            "test_score" : "100",
            "cut_score" : "100"
        }
    }}
    subject{post :upsert, post_params}
    
    it "inserts a new record" do

        
    end

    it "updates an existing record" do
    end

    it "returns http success" do
    end

    it "returns a success message" do
    end

  end

  describe "failed upsert" do

    describe "bad Bnum" do

        it "returns http fail" do
        end

        it "returns error message" do
        end

    end

    describe "bad test code" do
        it "returns http fail" do
        end

        it "returns error message" do
        end

    end

    describe "missing result params" do
        it "returns http fail" do
        end

        it "returns error message" do
        end
    end
  end
  

end