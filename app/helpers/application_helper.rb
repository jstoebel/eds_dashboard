module ApplicationHelper

  	def name_details(student)

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

		return [first_name, last_name].join(' ')
		
	end

	def error_messages_for(object)
		render(:partial => 'application/error_messages', :locals => {:object => object})
	end
	
   def current_term(exact_term=true)
    # if exact match is requested, return nil if not in a curent term. 
    # Otherwise, return the most recent passed turn.

    term = BannerTerm.where("StartDate<=:now and EndDate>=:now", {now: Date.today}).first

    if term
      return BannerTerm.find(term)

    else
      if exact_term
        return nil

      else
        #give me the last term that ended before Date.today
        term = BannerTerm.where("EndDate<:now", {now: Date.today}).order(EndDate: :desc).first
        return BannerTerm.find(term)
      end
      
    end

   end



end
