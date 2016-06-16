require 'test_helper'
require 'test_teardown'

class BannerUpdatesControllerTest < ActionController::TestCase

  before do
    @controller = Api::V1::BannerUpdatesController.new
  end

  describe "create success" do

    let(:params){
        {:banner_update => {
            :start_term => BannerTerm.first.id,
            :end_term => BannerTerm.second.id
            }
        }

    }

    subject{post :create, params}

    it "creates an update" do
        before_count = BannerUpdate.all.size
        subject
        expect BannerUpdate.all.size.must_equal before_count+1
    end

    it "renders http success" do
        subject
        assert_response :success

    end

    it "returns success message" do
        subject
        body = JSON.parse(response.body)
        expect body["success"].must_equal true
        expect body["msg"].must_equal "Successfully updated banner_update"

    end

  end

  describe "create fail" do

    let(:first){BannerTerm.first}

    let(:params){
        {:banner_update => {
            :start_term => BannerTerm.second.id,
            :end_term => first.id
            }
        }

    }

    subject{post :create, params}

    it "does not create an update" do
        before_count = BannerUpdate.all.size
        subject
        expect BannerUpdate.all.size.must_equal before_count

    end

    it "renders http unprocessable" do
        subject
        assert_response :unprocessable_entity
    end

    it "returns error message" do
        subject
        body = JSON.parse(response.body)
        expect body["success"].must_equal false
        expect body["msg"].must_equal ["Start term must be less than or equal to #{first.id}"]
    end
  end
  

end