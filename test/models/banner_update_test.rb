# == Schema Information
#
# Table name: banner_updates
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  start_term :integer
#  end_term   :integer
#

require 'test_helper'

class BannerUpdateTest < ActiveSupport::TestCase

    describe "validates presence of terms" do
        [:start_term, :end_term].each do |i|
            it "validates presence of #{i}" do
                u = BannerUpdate.new
                assert_not u.valid?
                assert_includes u.errors.full_messages, "#{i.to_s.humanize} can't be blank" 
            end
        end
    end

    it "validates start_term is not larger than end_term" do
        u = BannerUpdate.new({:start_term => (BannerTerm.second), :end_term => (BannerTerm.first)})
        assert_not u.valid?
    end
end
