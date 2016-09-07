require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  describe "index" do

    before do

      @records = []

      ["227", "228", "440", "479"].each do |code|
        course = FactoryGirl.create :transcript, {:course_code => "EDS#{code}",
          :grade_pt => 3.0
        }
        @records.push course
      end
      get :index

    end

    test "http 200" do
      assert false
    end

    describe "pulls records" do

      test "basic info matches" do
        # Bnum though Minors is correct for each record
        assert false
      end

      test "matches taken 227/228" do
        assert false

      end

      test "matches completed 227/228" do
        assert false

      end

      test "matches term for 440/479" do
        assert false
      end

    end

  end

end
