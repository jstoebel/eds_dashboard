class StFile < ActiveRecord::Base

    belongs_to :adm_st
    belongs_to :student_file

    validates :adm_st_id,
      :presence => true

    validates :student_file_id,
        :presence => true,
        :uniqueness => {message: "This file is already associated."}
        
end
