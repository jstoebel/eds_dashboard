# == Schema Information
#
# Table name: pgp_goals
#
#  id         :integer          not null, primary key
#  student_id :integer
#  name       :string(255)
#  domain     :string(255)
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

include Faker
FactoryGirl.define do
  factory :pgp_goal do
    student
    name { Hipster.word }
    domain do
      [
        'Planning and Preparation',
        'Classroom Environment',
        'Instruction',
        'Professional Responsibilities'].sample
    end
    active { Boolean.boolean }
  end
end