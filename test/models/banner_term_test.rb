# == Schema Information
#
# Table name: banner_terms
#
#  BannerTerm :integer          not null, primary key
#  PlainTerm  :string(45)       not null
#  StartDate  :datetime         not null
#  EndDate    :datetime         not null
#  AYStart    :integer          not null
#

require 'test_helper'

class BannerTermTest < ActiveSupport::TestCase

    let(:fall_date) {Date.new(2015, 10, 1)}
    let(:fall_term) {BannerTerm.find 201511}

    let(:spring_date) {Date.new(2016, 3, 1)}
    let(:spring_term) {BannerTerm.find 201512}

    let(:summer_term) {BannerTerm.find 201513}

    it "gets current_term for today (exact)" do
        travel_to fall_date do
            t = BannerTerm.current_term
            expect t.id.must_equal 201511
        end
    end

    it "gets nil when outside term (exact)" do
        travel_to fall_term.StartDate - 1 do
            t = BannerTerm.current_term
            expect t.must_be_nil
        end
    end

    it "gets current_term for other date (exact)" do
        t = BannerTerm.current_term({:date => fall_date})
        expect t.id.must_equal 201511
    end

    it "gets current_term outside term (back)" do
        travel_to fall_term.EndDate + 1 do
            t = BannerTerm.current_term({:exact => false, :plan_b => :back})
            expect t.id.must_equal 201511
        end
    end

    it "gets current_term outside term (forward)" do
        travel_to((fall_term.StartDate)-1) do
            t = BannerTerm.current_term({:exact => false, :plan_b => :forward})
            expect t.id.must_equal 201511
        end
    end

    it "raises error with bad plan_b" do

        assert_raises(RuntimeError) {BannerTerm.current_term(:date => (fall_term.StartDate)-1,
         :exact => false, :plan_b => :spam)}
    end

    it "gets the next term" do
        next_t = fall_term.next_term
        expect next_t.id.must_equal 201512
    end

    it "gets prev term" do
        prev_t = spring_term.prev_term
        expect prev_t.id.must_equal 201511
    end

    it "returns readable no extra text" do
        expect fall_term.readable.must_equal fall_term.PlainTerm
    end

    it "returns readable with helper text" do
        expect summer_term.readable.must_equal "#{summer_term.PlainTerm} (#{summer_term.AYStart}-#{summer_term.AYStart+1})"
    end

end
