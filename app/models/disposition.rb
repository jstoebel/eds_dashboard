# == Schema Information
#
# Table name: dispositions
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :text(65535)
#  current     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Disposition < ApplicationRecord
  has_many :issues

  validates :code,
    :presence => {:message => "Disposition must have a code (example 1.1)"}

  validates :description,
    :presence => {:message => "Disposition must have a description"}

  validates :current,
    :presence => {:message => "Disposition must be marked as current or not current"}

  scope :current, lambda {where(current: true)}
  scope :ordered, lambda {order(:code)}

end
