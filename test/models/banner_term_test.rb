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

    # let(:fall_date) {Date.new(2015, 10, 1)}
    # let(:fall_term) {BannerTerm.find 201511}
    #
    # let(:spring_date) {Date.new(2016, 3, 1)}
    # let(:spring_term) {BannerTerm.find 201512}
    #
    # let(:summer_term) {BannerTerm.find 201513}
    #
    # let(:last_summer_term) {BannerTerm.find 201515}
    #
    # let(:next_fall_term) {BannerTerm.find 201611}
    let(:past_term) {FactoryGirl.create :banner_term, {:BannerTerm => 10,
        :StartDate => 40.days.ago,
        :EndDate => 30.days.ago
        }}

    let(:past_overlap) {FactoryGirl.create :banner_term, {:BannerTerm => 20,
        :StartDate => 20.days.ago,
        :EndDate => Date.today
        }}

    let(:term_today) {FactoryGirl.create :banner_term, {:BannerTerm => 30,
        :StartDate => 10.days.ago,
        :EndDate => 10.days.from_now
      }}

    let(:future_overlap) {FactoryGirl.create :banner_term, {:BannerTerm => 40,
        :StartDate => Date.today,
        :EndDate => 20.days.from_now
      }}

    let(:future_term) {FactoryGirl.create :banner_term, {:BannerTerm => 50,
        :StartDate => 30.days.from_now,
        :EndDate => 40.days.from_now
        }}

    it "gets current_term for today (exact)" do
      this_term = term_today
      assert_equal this_term, BannerTerm.current_term
    end

    it "gets nil when outside term (exact)" do
      t = BannerTerm.current_term
      assert_nil t
    end

    it "gets current_term for other date (exact)" do
        this_term = term_today
        t = BannerTerm.current_term({:date => 1.day.ago})
        assert t, this_term
    end

    it "gets current_term outside term (back)" do
      before_term = past_term
      assert_equal before_term, BannerTerm.current_term({:exact => false, :plan_b => :back})
    end

    it "gets current_term outside term (forward)" do
      after_term = future_term
      assert_equal after_term, BannerTerm.current_term({:exact => false, :plan_b => :forward})
    end

    it "raises error with bad plan_b" do
      # this_term = term_today
      assert_raises(RuntimeError) { BannerTerm.current_term(:exact => false, :plan_b => :spam) }
    end

    describe "next_term" do
      before do
        @curr_term = term_today
      end
      test "not exclusive" do
        overlap = future_overlap
        assert_equal overlap, @curr_term.next_term
      end
      test "exclusive" do
        exclusive_future = future_term
        assert_equal exclusive_future, @curr_term.next_term(exclusive=true)
      end

    end

    describe "prev_term" do
      before do
        @curr_term = term_today
      end
      test "not exlucive" do
        overlap = past_overlap
        assert_equal overlap, @curr_term.prev_term
      end

      test "exclusive" do
        exclusive_past = past_term
        assert_equal exclusive_past, @curr_term.prev_term(exclusive=true)
      end

    end

    it "returns readable no extra text" do
        term = FactoryGirl.create :banner_term, {
          :PlainTerm => "Fall 1855"
        }
        assert_equal term.PlainTerm, term.readable
    end

    it "returns readable with helper text" do
      term = FactoryGirl.create :banner_term, {
        :PlainTerm => "Fall Term"
      }
      assert_equal "#{term.PlainTerm} (#{term.AYStart}-#{term.AYStart+1})", term.readable
    end

    it "filters out begining and end of time" do
        past_term
        term_today
        future_term
        filtered = BannerTerm.actual
        assert_not_equal filtered.first.id, 0
        assert_not_equal filtered.last.id, 999999
    end

end
