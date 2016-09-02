# Preview all emails at http://localhost:3000/rails/mailers/praxis_result_mailer
class PraxisResultMailerPreview < ActionMailer::Preview
  def email_student
    stu = FactoryGirl.build_stubbed :student, :Email => "student@test.edu"

    praxis_tests = [] # one passing and one non passing test
    [1, -1].each do |modifier|
      pr = FactoryGirl.build_stubbed :praxis_result
      pr.test_score = (pr.cut_score) + modifier
      praxis_tests.push pr
    end

    adv = FactoryGirl.build_stubbed :tep_advisor
    PraxisResultMailer.email_student(stu, praxis_tests)
  end
end
