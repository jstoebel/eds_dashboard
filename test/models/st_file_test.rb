require 'test_helper'

class StFileTest < ActiveSupport::TestCase
    describe "required field" do
        before do
            @record = StFile.new
            @record.valid?
        end

        [:adm_st_id, :student_file_id].each do |attr|
            test attr do
                assert @record.errors[attr].present?
            end
        end
    end

    test "student_file can't repeat" do
        adm_st = FactoryGirl.create :accepted_adm_st
        second_file = StFile.new({
            :adm_st_id => adm_st.id,
            :student_file_id => adm_st.st_files.first.student_file_id
        })

        second_file.valid?
        assert_equal ["This file is already associated."], second_file.errors[:student_file_id]
    end
end
