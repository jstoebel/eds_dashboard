class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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
   
   #methods for working with terms

   def to_console(object)
    puts "*"*100
    puts object
    puts "*"*100
   end

end
