# == Schema Information
#
# Table name: students
#
#  id                      :integer          not null, primary key
#  Bnum                    :string(9)        not null
#  FirstName               :string(45)       not null
#  PreferredFirst          :string(45)
#  MiddleName              :string(45)
#  LastName                :string(45)       not null
#  PrevLast                :string(45)
#  EnrollmentStatus        :string(45)
#  Classification          :string(45)
#  CurrentMajor1           :string(45)
#  concentration1          :string(255)
#  CurrentMajor2           :string(45)
#  concentration2          :string(255)
#  CellPhone               :string(45)
#  CurrentMinors           :string(255)
#  Email                   :string(100)
#  CPO                     :string(45)
#  withdraws               :text(65535)
#  term_graduated          :integer
#  gender                  :string(255)
#  race                    :string(255)
#  hispanic                :boolean
#  term_expl_major         :integer
#  term_major              :integer
#  presumed_status         :string(255)
#  presumed_status_comment :text(65535)
#

module StudentsHelper
end
