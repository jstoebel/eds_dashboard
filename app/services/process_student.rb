class ProcessStudent
  # a service object to process a single student

  attr_reader  :row, :stu, :course

   def initialize(row)
     # row: a row extracted from Banner query
     @row = row
     @stu = Student.find_or_initialize_by :Bnum => row['szvedsd_id']
   end

   def upsert_student
     # upserts a student.

      @stu.assign_attributes({:FirstName => @row['szvedsd_first_name'],
        :MiddleName => @row['szvedsd_middle_name'],
        :LastName => @row['szvedsd_last_name'],
        :EnrollmentStatus => @row['szvedsd_enroll_stat'],
        :Classification => @row['szvedsd_classification'],
        :CurrentMajor1 => @row['szvedsd_primary_major'],
        :concentration1 => @row['szvedsd_primary_major_conc'],
        :CurrentMajor2 => @row['szvedsd_secondary_major'],
        :concentration2 => @row['szvedsd_secondary_major_conc'],
        :CurrentMinors => @row['szvedsd_minors'],
        :Email => @row['szvedsd_email'],
        :CPO => @row['szvedsd_cpo'],
        :withdraws => @row['szvedsd_withdrawals'],
        :term_graduated => @row['szvedsd_term_graduated'],
        :gender => @row['szvedsd_gender'],
        :race => @row['szvedsd_race'],
        :hispanic => @row['szvedsd_hispanic'].andand.downcase=='yes' ? true : false,
        :term_expl_major => @row['szvedsd_term_eds_explor_mjr'],
        :term_major => @row['szvedsd_term_declared_eds_mjr']
     })

     # email alert if candidate appears to have left program according to concentration change
     # dismissed, or transfer

     if ((@stu.was_eds_major? && !@stu.is_eds_major?) ||
        (@stu.was_cert_concentration? && !@stu.is_cert_concentration?)) &&
        (@stu.open_programs)
        @stu.tep_advisors.each do |adv|
          BannerUpdateMailer.possible_drop(@stu, adv).deliver_now
        end
     end

     @stu.save!

   end

   def update_advisor_assignments
     # determines any changes in advisor assignments and adds/removes to match.
     # example: FirstName LastName {Primary-B00xxxxxx}; FirstName LastName {Minor-B00xxxxxx}

     advisors_raw = @row['szvedsd_advisor']
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
         if @stu.EnrollmentStatus == "Active Student"
           BannerUpdateMailer.add_drop_advisor(@stu, adv, "added").deliver_now
         end
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
         if @stu.EnrollmentStatus == "Active Student"
           BannerUpdateMailer.add_drop_advisor(@stu, adv, "removed").deliver_now
         end
       end
     end

   end

   def upsert_course

     term_raw = @row['szvedsd_term_taken']  #looks like this 201512 - Spring Term 2016
     #split at first dash
     term = term_raw.slice(0, term_raw.index('-')).strip

     course_raw = @row['szvedsd_course']    # looks like this SOC 220X  - Social Problems
     delim = course_raw.index('-')

     begin
       code_section, course_name = [course_raw[0..delim-1], course_raw[delim + 1..-1]].map{|i| i.strip}
     rescue NoMethodError => e
       # fall back in the case of very strange courses
       code_section = course_raw
       course_name = nil
     end

     code_section.gsub!(" ", "")  #course code should look like "SOC220X"
     code_sec_match = /^(?<course_code>[A-Z]{3,4}[0-9]{3})(?<section>.*)$/.match(code_section)

     # if parse was successful assign code and section otherwise dump it all into course code
     if code_sec_match.present?
       course_code = code_sec_match[:course_code]
       course_section = code_sec_match[:section]
     else
       course_code = code_section
       course_section = nil
     end

     grade_ltr = @row['szvedsd_grade']
     grade_pt = Transcript.l_to_g(grade_ltr)

     @course = Transcript.find_or_initialize_by({:crn => row['szvedsd_crn'],
       :student_id => @stu.id,
       :term_taken => term
     })

     @course.update_attributes!({:course_code => course_code,
        :course_name => course_name,
        :course_section => course_section,
        :grade_pt => grade_pt,
        :grade_ltr => grade_ltr,
        :credits_attempted => @row['szvedsd_credits_attempted'],
        :credits_earned => @row['szvedsd_credits_earned'],
        :reg_status => @row['szvedsd_registration_stat'],
        :instructors => @row['savedsd_instructor'], # example format FirstName LastName {B00123456}; FirstName LastName {B00687001}
        :gpa_include => @row['szvedsd_gpa_ind'].andand.downcase == 'exclude' ? false : true
      })


   end

end
