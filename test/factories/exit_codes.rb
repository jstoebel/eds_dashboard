# == Schema Information
#
# Table name: exit_codes
#
#  id          :integer          not null, primary key
#  ExitCode    :string(5)        not null
#  ExitDiscrip :string(45)       not null
#
include Faker
FactoryGirl.define do
  factory :exit_code do
    ExitDiscrip {Hipster.word}
    ExitCode { Number.between(1, 9999) }
  end
end
