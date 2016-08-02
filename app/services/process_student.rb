class ProcessStudent
  # a service object to process a single student

  attr_reader  :row, :stu

   def initialize(row)
     # row: a row extracted from Banner query
     @row = row
     @stu = Student.first_or_initialize :Bnum => row['SZVEDSD_ID']
   end

   def update
     # updates a student.
     # columns: LastName, EnrollmentStatus, Classification, Majors/Minors,
     # CPO, withdrawls, term_graduate, term_expl_major, term_major

     puts "updating #{@stu.name_readable}"
      @stu.assign_attributes({:LastName => @row['SZVEDSD_LAST_NAME'],
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
       :hispanic => @row['SZVEDSD_HISPANIC'].downcase=='yes' ? true : false,
       :term_expl_major => @row['SZVEDSD_TERM_EDS_EXPLOR_MJR'],
       :term_major => @row['SZVEDSD_TERM_DECLARED_EDS_MJR']
     })

     # email alert if candidate appears to have left program according to concentration change
     # dismissed, or transfer

     if (@stu.was_eds_major? && !@stu.is_eds_major?) ||
        (@stu.was_cert_concentration? && !@stu.is_cert_concentration)

        # TODO EMAIL ALERT!

     end

     @stu.save! #error will be caught by the caller.

   end

   def upsert
     # upserts a student.

      @stu.update_attributes({:FirstName => @row['SZVEDSD_FIRST_NAME'],
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
       :hispanic => @row['SZVEDSD_HISPANIC'].downcase=='yes' ? true : false,
       :term_expl_major => @row['SZVEDSD_TERM_EDS_EXPLOR_MJR'],
       :term_major => @row['SZVEDSD_TERM_DECLARED_EDS_MJR']
     })

     # email alert if candidate appears to have left program according to concentration change
     # dismissed, or transfer

     if ((@stu.was_eds_major? && !@stu.is_eds_major?) ||
        (@stu.was_cert_concentration? && !@stu.is_cert_concentration)) &&
        (@stu.open_programs)
        puts "EMAIL ALERT: #{@stu.name_readable} is not a TEP student any more!"
        # TODO EMAIL ALERT!
     end

     puts "upserted #{@stu.name_readable}"

   end

   def update_advisor_assignments
     # determines any changes in advisor assignments and adds/removes to match.
     # example: FirstName LastName {Primary-B00xxxxxx}; FirstName LastName {Minor-B00xxxxxx}

     advisors_raw = @row['SZVEDSD_ADVISOR']
     advisors = advisors_raw.split ";" # array of each advisor with B#
     info = advisors_raw.split(";").map{ |adv| adv.match(/\{(.+)\}/i)[1] } # array like this ["Primary-B00xxxxxx", "Minor-B00xxxxxx"]
     # note: don't handle hypen above as ad advisor name might contain a hyphen.

     new_bnums = info.map{ |i| i.match(/.+-(.+)/i)[1]}
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

end
