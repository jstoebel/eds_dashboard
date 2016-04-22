class StudentFilesController < ApplicationController
  authorize_resource

  def index
    index_setup
  end

  def create
    @file = StudentFile.new
    student = Student.find params[:student_id]
    @file.student_id = student.id
    @file.doc = params[:student_file][:doc]

    authorize! :manage, @file

    if @file.save
      flash[:notice] = "File successfully uploaded."
      redirect_to student_student_files_path(student.id)
    else
      index_setup
      flash[:notice] = "Error uploading file."
      @student = Student.find params[:student_id]
      
      render 'index'      
    end
  end

  def destroy
    @file = StudentFile.find(params[:id])
    @file.active = false

    authorize! :manage, @file
    if @file.save
      flash[:notice] = "File successfully removed."
      redirect_to student_student_files_path(@file.student.id)
    else
      flash[:notice] = "Error removing file."
      redirect_to student_student_files_path(@file.student.id)      
    end
  end

  def download
    file = StudentFile.find(params[:student_file_id])
    authorize! :read, file
    send_file file.doc.path
  end

  private

  def index_setup
    @student = Student.find params[:student_id]
    authorize! :read, @student
    ability = Ability.new(current_user)
    @docs = @student.student_files.active.select {|r| ability.can? :read, r }
  end

end
