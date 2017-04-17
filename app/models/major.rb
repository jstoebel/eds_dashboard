# == Schema Information
#
# Table name: majors
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Major < ApplicationRecord
    has_many :foi
end
