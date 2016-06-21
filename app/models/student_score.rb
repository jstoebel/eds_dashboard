# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  student_id         :integer          not null
#  assessment_version_id  :integer      not null
#  assessment_item_id :integer          not null
#  item_level_id      :integer          not null
#  created_at         :datetime
#  updated_at         :datetime
#

=begin
=end

class StudentScore < ActiveRecord::Base
    has_many :students
    has_many :assessment_versions
    has_many :item_levels
    has_many :assessment_items
    
    validates_presence_of :student_id, :assessment_version_id, :assessment_item_id, :item_level_id
end