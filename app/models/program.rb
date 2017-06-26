# == Schema Information
#
# Table name: programs
#
#  id           :integer          not null, primary key
#  ProgCode     :string(10)       not null
#  EPSBProgName :string(100)
#  EDSProgName  :string(45)
#  Current      :boolean
#  license_code :string(255)
#

# a single EPSB program

class Program < ApplicationRecord
  has_many :adm_tep, {:foreign_key => 'Program_ProgCode'}
  has_many :students, {:foreign_key => 'Program_ProgCode', through: :adm_tep}
  has_many :prog_exits, {:foreign_key => 'Program_ProgCode'}
  has_many :majors
  has_many :praxis_tests, :foreign_key => "Program_ProgCode"

  def repr
    # what to display for rails_admin
    return self.EPSBProgName
  end
end
