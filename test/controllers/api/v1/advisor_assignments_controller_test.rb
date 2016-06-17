require 'test_helper'
require 'test_teardown'

class StudentsControllerTest < ActionController::TestCase

  before do
    @controller = Api::V1::AdvisorAssignments.new
  end

  describe "create success" do

    let(:stu){FactoryGirl.create :student}
    let(:usr){FactoryGirl.create :advisor}
    let(:adv){FactoryGirl.create :usr.tep_advisor}


    it "adds new advisors" do
    end

    it "removes old advisors" do
    end

    it "returns http sucess" do
    end

    it "returns a sucess message" do
    end

  end

end