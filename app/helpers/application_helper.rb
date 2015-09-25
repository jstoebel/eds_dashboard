module ApplicationHelper

	def name_details(student, file_as = false)
    #returns full student name with additional first and last names as needed
    #if file_as, return student with last name first (Fee, Jon)

		if student.PreferredFirst
			first_name = student.PreferredFirst + " (#{student.FirstName})"
		else
			first_name = student.FirstName
		end

		if student.PrevLast
			last_name = student.LastName + " (#{student.PrevLast})"
		else
			last_name = student.LastName

		end

    if file_as
      return [last_name+',', first_name].join(' ')  #return last name first
    
    else
      return [first_name, last_name].join(' ')  #return first name first
    end


		
	end

	def error_messages_for(object)
		render(:partial => 'application/error_messages', :locals => {:object => object})
	end
	
  def current_term(options = {})


    defaults = {
      :exact => true,
      :plan_b => :forward
    }


    # if exact match is requested, return nil if not in a curent term. 
    # Otherwise, return the most recent or next term, as requested.

    term = BannerTerm.where("StartDate<=:now and EndDate>=:now", {now: Date.today}).first

    if term
      return BannerTerm.find(term)

    else
      if options[:exact]
        return nil

      else  #go to plan-b
        if options[:plan_b] == :back
          #give me the last term that ended before Date.today
          return BannerTerm.where("EndDate<:now", {now: Date.today}).order(EndDate: :desc).first
        elsif options[:plan_b] == :forward
          #give me the first term that begins after today
          return BannerTerm.where("StartDate>:now", {now: Date.today}).order(StartDate: :asc).first

        else
          raise "Must select forward or back for plan_b"
        end


      end
      
    end

  end

   def banner_to_plain(banner_term)
   	#converts a banner term to its normal name
   	term = BannerTerm.find(banner_term)
   	return term.PlainTerm
   end

   def praxisI_pass(student)
   	#input a Student instance
   	#output if student has passed all praxis I exams.
   	
	   	req_tests = PraxisTest.where(TestFamily: 1, CurrentTest: 1).map{ |t| t.TestCode}
	   	passings = PraxisResult.where(Bnum: student.Bnum, Pass: 1).map{ |p| p.TestCode}

	   	req_tests.each do |requirement|
	   		if not passings.include? requirement
	   			return false	#found a required test student hasn't passed
   			end

	   	end

	   	return true		#failed to find a required test student hasn't passed.

   end

   def string_to_bool(i)
   		if i.downcase=="true"
   			return true
		else if i.downcase=="false"
			return false
		else
			return nil
		end
   end


  end
end
