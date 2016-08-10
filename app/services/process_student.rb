class ProcessStudent
  # a service object to process a single student

  attr_reader  :row, :stu

   def initialize(row)
     # row: a row extracted from Banner query
     @row = row
     @stu = Student.find_or_initialize_by :Bnum => row['SZVEDSD_ID']
   end

   def upsert_student
     # upserts a student.
    #  puts "Upserting student record for #{@stu.name_readable}..."

      @stu.update_attributes!({:FirstName => @row['SZVEDSD_FIRST_NAME'],
        :MiddleName => @row['SZVEDSD_MIDDLE_NAME'],
        :LastName => @row['SZVEDSD_LAST_NAME'],
        :EnrollmentStatus => @row['SZVEDSD_ENROLL_STAT'],
        :Classification => @row['SZVEDSD_CLASSIFICATION'],
        :CurrentMajor1 => @row['SZVEDSD_PRIMARY_MAJOR'],
        :concentration1 => @row['SZVEDSD_PRIMARY_MAJOR_CONC '],
        :CurrentMajor2 => @row['SZVEDSD_SECONDARY_MAJOR'],
        :concentration2 => @row['SZVEDSD_SECONDARY_MAJOR_CONC'],
        :CurrentMinors => @row['SZVEDSD_MINORS'],
        :Email => @row['SZVEDSD_EMAIL'],
        :CPO => @row['SZVEDSD_CPO'],
        :withdraws => @row['SZVEDSD_WITHDRAWALS'],
        :term_graduated => @row['SZVEDSD_TERM_GRADUATED'],
        :gender => @row['SZVEDSD_GENDER'],
        :race => @row['SZVEDSD_RACE'],
        :hispanic => @row['SZVEDSD_HISPANIC'].andand.downcase=='yes' ? true : false,
        :term_expl_major => @row['SZVEDSD_TERM_EDS_EXPLOR_MJR'],
        :term_major => @row['SZVEDSD_TERM_DECLARED_EDS_MJR']
     })

     # email alert if candidate appears to have left program according to concentration change
     # dismissed, or transfer
     if ((@stu.was_eds_major? && !@stu.is_eds_major?) ||
        (@stu.was_cert_concentration? && !@stu.is_cert_concentration?)) &&
        (@stu.open_programs)
        puts "EMAIL ALERT: #{@stu.name_readable} is not a TEP student any more!"

        @stu.tep_advisors.each |adv| do
          BannerUpdateMailer.possible_drop(@stu, adv).deliver_now
        end
     end

   end

   def update_advisor_assignments
     # determines any changes in advisor assignments and adds/removes to match.
     # example: FirstName LastName {Primary-B00xxxxxx}; FirstName LastName {Minor-B00xxxxxx}
    #  puts "updating advisors for #{@stu.name_readable}: #{@stu.Bnum}"
     advisors_raw = @row['SZVEDSD_ADVISOR']
     if advisors_raw.present?
       advisors = advisors_raw.split ";" # array of each advisor with B#
       info = advisors_raw.split(";").map{ |adv| adv.match(/\{(.+)\}/i)[1] } # array like this ["Primary-B00xxxxxx", "Minor-B00xxxxxx"]
       # note: don't handle hypen above as ad advisor name might contain a hyphen.

       new_bnums = info.map{ |i| i.match(/.+-(.+)/i)[1]}
     else
       new_bnums = []
     end

     current_bnums = stu.advisor_assignments.map{ |assignment| assignment.tep_advisor.AdvisorBnum}
     add_me = new_bnums - current_bnums # in new and not in current_bnums
     add_me.each do |bnum|
       #try to find the advisor
       adv = TepAdvisor.find_by :AdvisorBnum => bnum

       if !adv.nil?
         AdvisorAssignment.create({:student_id => stu.id,
             :tep_advisor_id => adv.id
         })
       end
     end

     delete_me = current_bnums - new_bnums # in current and not in new

     delete_me.each do |bnum|
       adv = TepAdvisor.find_by :AdvisorBnum => bnum
       if !adv.nil?
         assignment = AdvisorAssignment.find_by({:student_id => stu.id,
             :tep_advisor_id => adv.id
         })
         assignment.destroy!
       end
     end

   end

   def upsert_course

    #  puts "Upserting course for #{@stu.name_readable}: #{@stu.Bnum}"

     term_raw = @row['SZVEDSD_TERM_TAKEN']  #looks like this 201512 - Spring Term 2016
     #split at first dash
     term = term_raw.slice(0, term_raw.index('-')).strip

     course_raw = @row['SZVEDSD_COURSE']    # looks like this SOC 220X  - Social Problems
     delim = course_raw.index('-')

     course_code, course_name = [course_raw[0..delim-1], course_raw[delim + 1..-1]].map{|i| i.strip}
     course_code.gsub!(" ", "")  #course code should look like "SOC220X"

     grade_ltr = @row['SZVEDSD_GRADE']
     grade_pt = Transcript.g_to_l(grade_ltr)

     @course = Transcript.find_or_initialize_by({:crn => row['SZVEDSD_CRN'],
       :student_id => @stu.id,
       :term_taken => term
     })

     @course.update_attributes!({:course_code => course_code,
        :course_name => course_name,
        :grade_pt => grade_pt,
        :grade_ltr => grade_ltr,
        :credits_attempted => @row['SZVEDSD_CREDITS_ATTEMPTED'],
        :credits_earned => @row['SZVEDSD_CREDITS_EARNED'],
        :reg_status => @row['SZVEDSD_REGISTRATION_STAT'],
        :instructors => @row['SAVEDSD_INSTRUCTOR'], # example format FirstName LastName {B00123456}; FirstName LastName {B00687001}
        :gpa_include => @row['SZVEDSD_GPA_IND'].andand.downcase == 'include' ? true : false
      })

   end

end
