# == Schema Information
#
# Table name: majors
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Major < ActiveRecord::Base
    has_many :foi
    has_many :majors_programs
end
