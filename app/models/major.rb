# == Schema Information
#
# Table name: majors
#
#  id   :integer          not null, primary key
#  name :string(255)
#

# possible major (not same as a program)
class Major < ApplicationRecord
    has_many :foi
end
