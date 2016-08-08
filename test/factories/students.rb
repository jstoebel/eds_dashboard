# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  concentration1   :string(255)
#  CurrentMajor2    :string(45)
#  concentration2   :string(255)
#  CellPhone        :string(45)
#  CurrentMinors    :string(255)
#  Email            :string(100)
#  CPO              :string(45)
#  withdraws        :text(65535)
#  term_graduated   :integer
#  gender           :string(255)
#  race             :string(255)
#  hispanic         :boolean
#  term_expl_major  :integer
#  term_major       :integer
#

include Faker

FactoryGirl.define do
  factory :student do

    # sequence(:Bnum) { |n| "B00#{n.to_s.rjust(6, '0')}" }

    Bnum do
      bnums = Student.all.pluck :Bnum

      while true do
        random_n = Number.between(0, 10**6)
        bnum = "B00#{random_n.to_s.rjust(6, '0')}"
        break if !bnums.include? bnum
      end
      bnum
    end

    FirstName {Name.first_name}
    LastName {Name.last_name}
    EnrollmentStatus "Active Student"

  end
end
