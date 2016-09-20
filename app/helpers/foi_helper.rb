module FoiHelper
    
    def _import_foi(row)
    # row: a csv row
    # creates an foi record or raises an error if student can't be determined 
        eds_only = row["Q2.1 - Do you intend to seek an Education Studies degree without certification?"].downcase == "yes"
        seek_cert = row["Q1.4 - Do you intend to seek teacher certification at Berea College?"].downcase == "yes"
        new_form = row["Q1.3 - Are you completing this form for the first time, or is this form a revision..."].downcase == "new form"
  
        major_name = row["Q3.1 - Which area do you wish to seek certification in?"] # the raw name of the major from the file
        major = Major.find_by major_name
      
        date_str = row["Recorded Date"]  #date completing, from the csv
        date = DateTime.strptime(date_str, "%m/%d/%Y")
      
        bnum = row["Q1.2_3 - B#"]
        if bnum.present?
      
            stu_id = Student.find_by({:Bnum => bnum}).id
        
        else 
        # find by first/last
            first_name = row["Q1.2_1 - First Name"]
            last_name = row["Q1.2_2 - Last Name"]
            soft_matches = Student.where({:FirstName => first_name, :LastName => last_name})
            if soft_matches.size == 1
                stu_id = soft_matches.first.id
            end
        
        end
      
        attrs = {
            :student_id => stu_id,
            :date_completing => date,
            :new_form => new_form,
            :major_id => major.id,
            :seek_cert => seek_cert,
            :eds_ony => eds_only
        }
      
        Foi.create!(attrs)
  
    end
    
  def _create_temp(row)
    # create a temporary record for user to match up later
    temp_foi.create!(attrs)
  
  end

end
