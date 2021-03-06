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

# represents a admission to TEP file

class AdmFile < ApplicationRecord
    belongs_to :adm_tep
    belongs_to :student_file

    validates :adm_tep_id,
      :presence => true

    validates :student_file_id,
        :presence => true,
        :uniqueness => {message: "This file is already associated."}
end
