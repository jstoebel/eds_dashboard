require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  describe "index" do

    before do

      ["227", "228", "440", "479"].each do |code|
        course = FactoryGirl.create :transcript, {:course_code => "EDS#{code}",
          :grade_pt => 3.0
        }
      end
      
      @stus = Student.all
      
      get :index

    end

    test "http 200" do
      assert_response :success
    end

    describe "pulls records" do

      test "basic info matches" do
        # Bnum though Minors is correct for each record
        expected_data = assigns(:data)
        
        # [:Bnum, ]
        
        expected_data.each_with_index do |val, idx|
          expected_hash = expected_data[idx]
          actual_stu = @stus[idx]
          
          attrs = [:Bnum, :name_readable, :prog_status, :CurrentMajor1, 
          :concentration1, :CurrentMajor2, :concentration2, :CurrentMinors]
          
          attrs.each do |attr|
            # assure each attribute for expected_hash matches actual_stu
            assert_equal expected_hash[attr], actual_stu.send(attr)  
          end
          
        end # loop
        

        # assert false
      end

      test "matches taken 227/228" do
        # assert false
      end

      test "matches completed 227/228" do
        # assert false

      end

      test "matches term for 440/479" do
        # assert false
      end

    end

  end

end
