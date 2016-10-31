# == Schema Information
#
# Table name: dispositions
#
#  id               :integer          not null, primary key
#  disp_code        :string(255)
#  disp_description :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Disposition < ActiveRecord::Base
  has_many :issues

  validates :disp_code,
    :presence => {:message => "Disposition must have a code (example 1.1)"}

  validates :disp_description,
    :presence => {:message => "Disposition must have a description"}
end
