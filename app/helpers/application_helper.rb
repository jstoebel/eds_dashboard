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

end
