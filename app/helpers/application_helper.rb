module ApplicationHelper

	def name_details(student, file_as = false)
    #returns full student name with additional first and last names as needed
    #if file_as, return student with last name first (Fee, Jon)

		if student.PreferredFirst.present?
			first_name = student.PreferredFirst + " (#{student.FirstName})"
		else
			first_name = student.FirstName
		end

		if student.PrevLast.present?
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
      :exact => true,         #bool, does the date need to match the term perfectly 
        #(dates outside of terms are rejected.)
      :plan_b => :forward,    #If not nil, what direction should we look to find the nearest term 
        #(if no exact match). Can be foward or back (symbol)
      :date => Date.today   #Date object
    }

    options = defaults.merge(options)

    #try to find the exact term
    term = BannerTerm.where("StartDate<=? and EndDate>=?", options[:date], options[:date]).first

    if term
      return term

    else
      if options[:exact]
        return nil

      else  #go to plan-b
        if options[:plan_b] == :back
          #give me the last term that ended before Date.today
          return BannerTerm.where("EndDate<?", options[:date]).order(EndDate: :desc).order(BannerTerm: :desc).first
        elsif options[:plan_b] == :forward
          #give me the first term that begins after today
          return BannerTerm.where("StartDate>?", options[:date]).order(StartDate: :asc).first

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

    if i == nil
      return nil
    else
      return true if i =~ (/^(true|True|TRUE)$/i)
      return false if i =~ (/^(false|False|FALSE)$/i)
    end

 	# 	if i.downcase=="true"
  #  			return true
		# elsif i.downcase=="false"
		# 	return false
		# else
		# 	return nil
		# end
  #  end
  end

end
