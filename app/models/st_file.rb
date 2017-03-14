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

class StFile < ActiveRecord::Base

    belongs_to :adm_st
    belongs_to :student_file

    validates :adm_st_id,
      :presence => true

    validates :student_file_id,
        :presence => true,
        :uniqueness => {message: "This file is already associated."}
        
end
