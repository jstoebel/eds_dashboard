require 'test_helper'
require 'test_teardown'

class TranscriptsControllerTest < ActionController::TestCase

  before do
  	@controller = Api::V1::TranscriptsController.new
  end

  describe "batch_upsert success" do
  	
  	let(:new_ts){FactoryGirl.build_list :transcript, 2}
	let(:t_attrs){ new_ts.map{|t| t.attributes.except(
  			"student_id").merge(
  			{:Bnum => Student.find(t.student_id).Bnum}
  			)}
  		}

  	it "creates two new records" do

  		before_count = Transcript.all.size
  		post :batch_upsert, {:transcripts => t_attrs}
  		assert_equal new_ts.size, (Transcript.all.size - before_count)
  	end

  	it "updates two records" do
  		new_ts.each {|i| i.save}
  		update_attrs = t_attrs.map{|i| i.merge({:grade_pt => 4.0})}
  		post :batch_upsert, {:transcripts => update_attrs}
  	end

  	it "returns 201" do
  		post :batch_upsert, {:transcripts => t_attrs}
  		assert_response :created
  	end

  	it "returns the expected success message" do
  		post :batch_upsert, {:transcripts => t_attrs}
  		resp = JSON.parse(response.body)
  		assert_equal "Successfully upserted #{t_attrs.size} records.", resp["msg"]
  		assert_equal true, resp["success"]
  	end

  end

  describe "batch_upsert fail" do

	let(:new_ts){FactoryGirl.build_list(:transcript, 2)}
	let(:t_attrs){new_ts.map{|t| t.attributes.except("student_id")}}

    it "changes nothing validation error" do
        before_count = Transcript.all.size
  		post :batch_upsert, {:transcripts => t_attrs}
        assert_equal before_count, Transcript.all.size
  	end

  	it "returns 422" do
        post :batch_upsert, {:transcripts => t_attrs}
  		assert_response :unprocessable_entity
  	end

  	it "returns the expected error message" do
        post :batch_upsert, {:transcripts => t_attrs}
        resp = JSON.parse(response.body)

        #generate the expected error message
        begin
            Transcript.create! t_attrs[0]
        rescue ActiveRecord::RecordInvalid => e
            assert_equal e.to_s, resp["msg"]
        end


  	end

  end

end