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
    PreferredFirst {Name.first_name}

    factory :admitted_student do
      after(:create) do |stu|
        # give course work, 12 courses

        course_term  = BannerTerm.find 201511

        courses = FactoryGirl.create_list :transcript, 12, {:student_id => stu.id,
          :grade_pt => 4.0,
          :grade_ltr => "A",
          :credits_earned =>  4.0,
          :term_taken => course_term.id,
          :gpa_include => true
        }
      end

      after(:create) do |stu|
        test_term = stu.transcripts.first.banner_term
        date_taken = test_term.StartDate
        p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})

        praxis_attrs = p1_tests.map { |test|
          FactoryGirl.attributes_for :praxis_result, {
            :student_id => stu.id,
            :praxis_test_id =>  test.id,
            :test_score => 101,
            :cut_score => 100,
            :test_date => date_taken,
            :reg_date => date_taken
          }
        }

        praxis_attrs.map { |t| PraxisResult.create t }
      end

      after(:create) do |stu|
        apply_term = stu.transcripts.first.banner_term.next_term

        app = FactoryGirl.create :adm_tep, {
          :student_id => stu.id,
          :TEPAdmitDate => apply_term.StartDate,
          :Program_ProgCode => Program.first.id,
          :BannerTerm_BannerTerm => apply_term.id
        }
      end

    end
  end
end
