FactoryGirl.define do
  factory :student do
    sequence(:Bnum) { |b| "B#{b.to_s.rjust(6, '0')}" }
    FirstName "Ima"
    LastName "Student"
    sequence(:AltID) { |i| "#{i}" }

    factory :prospective do
        ProgStatus "Prospetive"
        EnrollmentStatus "Active Student"
    end

    factory :candidate do
        ProgStatus "Candidate"
        EnrollmentStatus "Active Student"
    end

    factory :graduate_candidate do
        ProgStatus "Candidate"
        EnrollmentStatus "Graduation"
    end

    factory :graduate_completer do
        ProgStatus "Completer"
        EnrollmentStatus "Graduation"
    end
  end
end