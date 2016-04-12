FactoryGirl.define do

  factory :student do
    sequence(:Bnum) { |b| "B#{b.to_s.rjust(6, '0')}" }
    FirstName "Ima"
    LastName "Student"
    sequence(:AltID) { |i| "#{i}" }
  end
end