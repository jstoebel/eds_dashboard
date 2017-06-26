# == Schema Information
#
# Table name: st_files
#
#  id              :integer          not null, primary key
#  adm_st_id       :integer
#  student_file_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# a file attached to a student teaching application. the actual file is found at student_file
class StFile < ApplicationRecord

    belongs_to :adm_st
    belongs_to :student_file

    validates :adm_st_id,
      :presence => true

    validates :student_file_id,
        :presence => true,
        :uniqueness => {message: "This file is already associated."}
        
end
