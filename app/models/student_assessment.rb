# == Schema Information
#
# Table name: student_assessments
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  assessment_version_id :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

=begin
represents a single student begin scored on a single assessment version
=end

class StudentAssessment < ActiveRecord::Base

    belongs_to :student
    belongs_to :assessment_version

end
