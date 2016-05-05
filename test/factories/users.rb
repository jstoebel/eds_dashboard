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
        UserName { Faker::Internet.user_name }
        FirstName { Faker::Name.first_name }
        LastName { Faker::Name.last_name }
        Email { Faker::Internet.email }

        role_names = [:admin, :advisor, :staff, :stu_labor]
        role_names.each_with_index do |r, i|
            factory r do
                Roles_idRoles i+1

                if r == :advisor        #create a tep_advisor record for them if they are an advisor
                    after(:create) { |usr| FactoryGirl.create :tep_advisor, {:user_id => usr.id, :Salutation => usr.FirstName}}
                end
            end
        end
    end
end
