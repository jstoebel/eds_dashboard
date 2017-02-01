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

    test "adm_tep_id required" do
        
    end
end
