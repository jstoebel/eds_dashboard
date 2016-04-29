# == Schema Information
#
# Table name: assessment_item_versions
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  item_code             :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

=begin
Represents an association between an assessment item belonging on a paticular assessment version
=end

class AssessmentItemVersion < ActiveRecord::Base

    belongs_to :assessment_version
    belongs_to :assessment_item

    validates :item_code, 
      {:presence => 
          {message: "Please provide an item code."}
      }

    validates :assessment_version_id,
      {
        :uniqueness => { scope: :assessment_item_id, message: "Assessment version may not have the same item twice." }
      }
end
