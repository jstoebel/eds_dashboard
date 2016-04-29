# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  UserName      :string(45)       not null
#  FirstName     :string(45)       not null
#  LastName      :string(45)       not null
#  Email         :string(45)       not null
#  Roles_idRoles :integer          not null
#

FactoryGirl.define do
    factory :user do
        sequence(:UserName) { |b| "user#{b.to_s.rjust(3, '0')}" }
        sequence(:FirstName) { |b| Faker::Name.first_name }
        sequence(:LastName) { |b| Faker::Name.last_name }
        sequence(:Email) { |b| Faker::Internet.email }


        role_names = [:admin, :advisor, :staff, :stu_labor]
        role_names.each_with_index do |r, i|
            factory r do
                Roles_idRoles i+1
            end
        end
    end
end
