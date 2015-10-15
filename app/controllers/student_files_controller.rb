class StudentFilesController < ApplicationController
  def index
    @student = Student.from_alt_id(params[:student_id])
    @docs = @student.student_files
  end

  def new

  end

  def create
    @file = StudentFile.new
    student = Student.from_alt_id(params[:student_id])
    @file.Student_Bnum = student.Bnum
    @file.doc = params[:student_file][:doc]
    if @file.save
      flash[:notice] = "File successfully uploaded."
      redirect_to student_student_files_path(student.AltID)
    else
      flash[:notice] = "Error uploading file."
      redirect_to student_student_files_path(student.AltID)      
    end
  end

  def delete
  end

  def destroy
  end

  def download	
  end

end
