require 'test_helper'
class ClinicalTeacherTest < ActiveSupport::TestCase

  describe "advisor" do

    before do
      @advisor = FactoryGirl.create :advisor
      @abil = Ability.new @advisor

    end

    describe "IssueUpdate" do

      test "can manage if professor" do
        stu = make_student(@advisor)
        issue = FactoryGirl.create :issue, :student => stu
        update = FactoryGirl.create :issue_update, :issue => issue
        assert @abil.can? :manage, update
      end

      test "can manage if advisor" do
        stu = make_advisee(@advisor)
        issue = FactoryGirl.create :issue, :student => stu
        update = FactoryGirl.create :issue_update, :issue => issue
        assert @abil.can? :manage, update
      end

    end

    ["StudentFile", "ClinicalAssignment", "Pgp"].each do |resource|
      describe resource do

        test "can manage if professor" do
          stu = make_student(@advisor)
          record = FactoryGirl.create resource.underscore, :student => stu
          assert @abil.can? :manage, record
        end

        test "can manage if advisor" do
          stu = make_advisee(@advisor)
          record = FactoryGirl.create resource.underscore, :student => stu
          assert @abil.can? :manage, record
        end

      end
    end

    describe "PgpScore" do
      test "can manage if professor" do
        stu = make_student(@advisor)
        pgp = FactoryGirl.create :pgp, :student => stu
        pgp_score = FactoryGirl.create :pgp_score, :pgp => pgp
        assert @abil.can? :manage, pgp_score
      end

      test "can manage if advisor" do
        stu = make_advisee(@advisor)
        pgp = FactoryGirl.create :pgp, :student => stu
        pgp_score = FactoryGirl.create :pgp_score, :pgp => pgp
        assert @abil.can? :manage, pgp_score
      end
    end

    describe "Student" do
      test "can manage if professor" do
        stu = make_student(@advisor)
        assert @abil.can? :manage, stu
      end

      test "can manage if advisor" do
        stu = make_advisee(@advisor)
        pgp = FactoryGirl.create :pgp, :student => stu
        pgp_score = FactoryGirl.create :pgp_score, :pgp => pgp
        assert @abil.can? :manage, stu
      end
    end

    describe "IssueUpdate" do

      test "can manage if professor" do
        stu = make_student(@advisor)
        issue = FactoryGirl.create :issue, :student => stu
        update = FactoryGirl.create :issue_update, :issue => issue
        assert @abil.can? :manage, update
      end

      test "can manage if advisor" do
        stu = make_advisee(@advisor)
        issue = FactoryGirl.create :issue, :student => stu
        update = FactoryGirl.create :issue_update, :issue => issue
        assert @abil.can? :manage, update
      end
    end

    describe "Issue" do
      test "can manage if professor" do
        stu = make_student(@advisor)
        issue = FactoryGirl.create :issue, :student => stu
        assert @abil.can? :manage, issue
      end

      test "can manage if advisor" do
        stu = make_advisee(@advisor)
        issue = FactoryGirl.create :issue, :student => stu
        assert @abil.can? :manage, issue
      end

      test "can manage if authored" do
        adv = FactoryGirl.create :tep_advisor, :user => @advisor
        issue = FactoryGirl.create :issue, :tep_advisor => adv
        assert @abil.can? :manage, issue
      end

    end # issue

    test "can be concerned with Student" do
      stu = make_advisee(@advisor)
      assert @abil.can? :be_concerned, stu
    end

    [ClinicalTeacher, ClinicalSite].each do |resource|
      test "can manage #{resource}" do
        assert @abil.can? :manage, resource
      end
    end # resource loop

    describe "PraxisResult" do

      test "can read if professor" do
        stu = make_student(@advisor)
        result = FactoryGirl.create :praxis_result, :student => stu
        assert @abil.can? :read, result
      end

      test "can read if advisor" do
        stu = make_advisee(@advisor)
        result = FactoryGirl.create :praxis_result, :student => stu
        assert @abil.can? :read, result
      end
    end

    describe "PraxisSubtestResult" do

      test "can read if professor" do
        stu = make_student(@advisor)
        result = FactoryGirl.create :praxis_result, :student => stu
        subtest = FactoryGirl.create :praxis_subtest_result, :praxis_result => result
        assert @abil.can? :read, subtest
      end

      test "can read if advisor" do
        stu = make_advisee(@advisor)
        result = FactoryGirl.create :praxis_result, :student => stu
        subtest = FactoryGirl.create :praxis_subtest_result, :praxis_result => result
        assert @abil.can? :read, subtest
      end

    end # PraxisSubtestResult

  end # describe advisor

  describe "staff" do

    before do
      @staff = FactoryGirl.create :staff
      @abil = Ability.new @staff
    end

    [AdmSt, AdmTep, AlumniInfo, ClinicalAssignment, ClinicalSite, ClinicalTeacher,
      Employment, Foi, ProgExit, StudentFile].each do |resource|

      test "can manage #{resource}" do
          assert @abil.can? :read, resource
      end

    end

    [:write, :read, :report].each do |abil|
      test "can #{abil} Student" do
        assert @abil.can? abil, Student
      end
    end

    [:index, :create, :update, :delete, :destroy].each do |abil|
      test "can #{abil} PraxisResult" do
        assert @abil.can? abil, PraxisResult
      end
    end

  end # staff

  describe "student labor" do

    before do
      @stu_labor = FactoryGirl.create :staff
      @abil = Ability.new @stu_labor
    end

    test "read" do
      assert @abil.can? :read, Student
    end

    [ClinicalAssignment, ClinicalTeacher, ClinicalSite].each do |resource|
      test "can manage #{resource}" do
        assert @abil.can? :manage, resource
      end
    end

    [:index, :create, :update, :delete, :destroy].each do |abil|
      test "can #{abil} PraxisResult" do
        assert @abil.can? abil, PraxisResult
      end
    end

    [:index, :new, :create, :delete, :destroy].each do |abil|
      test "can #{abil} StudentFile" do
        assert @abil.can? abil, StudentFile
      end
    end

  end

end
