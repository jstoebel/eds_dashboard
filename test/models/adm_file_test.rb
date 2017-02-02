# == Schema Information
#
# Table name: adm_files
#
#  id              :integer          not null, primary key
#  adm_tep_id      :integer
#  student_file_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class AdmFileTest < ActiveSupport::TestCase

    describe "required field" do
        before do
            @record = AdmFile.new
            @record.valid?
        end

        [:adm_tep_id, :student_file_id].each do |attr|
            test attr do
                assert @record.errors[attr].present?
            end
        end
    end

    test "student_file can't repeat" do
        adm_tep = FactoryGirl.create :accepted_adm_tep
        second_file = AdmFile.new({
            :adm_tep_id => adm_tep.id,
            :student_file_id => adm_tep.adm_files.first.student_file_id
        })

        second_file.valid?
        assert_equal ["This file is already associated."], second_file.errors[:student_file_id]
    end

end
