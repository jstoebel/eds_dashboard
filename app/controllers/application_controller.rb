class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  	def name_details(student)

		if student.PreferredFirst
			@first_name = student.PreferredFirst + " (#{student.FirstName})"
		else
			@first_name = @student.FirstName
		end

		if student.PrevLast
			@last_name = student.LastName + " (#{student.PrevLast})"
		else
			@last_name = student.LastName

		end

		
	end
end
