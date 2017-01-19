require 'test_helper'
class ClinicalTeacherTest < ActiveSupport::TestCase

  describe "advisor" do

    before do
      @admin = FactoryGirl.create :admin
      @abil = Ability.new @admin
    end

    describe "IssueUpdate" do

      test "can manage if professor" do
        stu = make_student(@admin)
        issue = FactoryGirl.create :issue, :student => stu
        update = FactoryGirl.create :issue_update, :issue => issue
        assert @abil.can? :manage, update
      end

      test "can manage if advisor" do
        stu = make_advisee(@admin)
        issue = FactoryGirl.create :issue, :student => stu
        update = FactoryGirl.create :issue_update, :issue => issue
        assert @abil.can? :manage, update
      end

    end


    ["StudentFile", "ClinicalAssignment", "Pgp"].each do |resource|
      describe "resource" do

        test "can manage if professor" do
          stu = make_student(@admin)
          file = FactoryGirl.create :student_file, :student => stu
          assert @abil.can? :manage, file
        end

        test "can manage if advisor" do
          stu = make_advisee(@admin)
          file = FactoryGirl.create :student_file, :student => stu
          assert @abil.can? :manage, file
        end

      end
    end

    # also, PgpScore and Student

  end

end
