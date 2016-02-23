class StudentFilesController < ApplicationController
  authorize_resource

  def index
    index_setup
  end

  def create
    @file = StudentFile.new
    student = Student.from_alt_id(params[:student_id])
    @file.Student_Bnum = student.Bnum
    @file.doc = params[:student_file][:doc]

    authorize! :manage, @file

    if @file.save
      flash[:notice] = "File successfully uploaded."
      redirect_to student_student_files_path(student.AltID)
    else
      index_setup
      flash[:notice] = "Error uploading file."
      @student = Student.from_alt_id(params[:student_id])
      render 'index'      
    end
  end

  def destroy
    @file = StudentFile.find(params[:id])
    @file.active = false

    authorize! :manage, @file
    if @file.save
      flash[:notice] = "File successfully removed."
      redirect_to student_student_files_path(@file.student.AltID)
    else
      flash[:notice] = "Error removing file."
      redirect_to student_student_files_path(@file.student.AltID)      
    end
  end

  def download
    file = StudentFile.find(params[:student_file_id])
    authorize! :read, file
    send_file file.doc.path
  end

  private

  def index_setup
    @student = Student.from_alt_id(params[:student_id])
    authorize! :read, @student

    @adm_teps = AdmTep.where(Student_Bnum: @student.Bnum).where.not(letter_file_name: nil)
    
    @adm_sts = AdmSt.where(Student_Bnum: @student.Bnum).where.not(letter_file_name: nil)    
    
    ability = Ability.new(current_user)
    @docs = @student.student_files.active.select {|r| ability.can? :read, r }
  end

end
