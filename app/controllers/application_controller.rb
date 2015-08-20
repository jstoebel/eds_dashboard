class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  include ApplicationHelper
  
  protect_from_forgery with: :exception



  private
  	def find_student(alt_id)
  		return Student.where(AltID: alt_id).first
  		
  	end

  	def find_praxis_result(alt_stuid)
  		return PraxisResult.where(AltID: alt_stuid).first
  		
  	end

  	def find_issue(alt_stuid)
  		return Issue.where(AltID: alt_stuid).first
  	end


  	def name_details(student)

		if student.PreferredFirst
			@first_name = student.PreferredFirst + " (#{student.FirstName})"
		else
			@first_name = student.FirstName
		end

		if student.PrevLast
			@last_name = student.LastName + " (#{student.PrevLast})"
		else
			@last_name = student.LastName

		end

		
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

   def to_console(object)
    puts "*"*100
    puts object
    puts "*"*100
   end

end
