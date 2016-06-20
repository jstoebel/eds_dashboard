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
require 'test_helper'

class StudentScore < ActiveSupport::TestCase