class IssuesController < ApplicationController

  authorize_resource
  skip_authorize_resource :only => :new
  layout 'application'

  def new
  	@issue = Issue.new
  	@student = find_student(params[:student_id]) #AltID passed in here!
    name_details(@student)
  end

  def create

    @student = find_student(params[:student_id])
    
    @issue = Issue.new(new_issue_params)
    @issue.students_Bnum = @student.Bnum
    
    #assign advisor's B#
    user = current_user
    @issue.tep_advisors_AdvisorBnum = user.tep_advisor.AdvisorBnum
    authorize! :create, @issue   #make sure user is permitted to create issue for this student
    # 
    if @issue.save
      flash[:notice] = "New issue opened for: #{name_details(@student)}"
      redirect_to(student_issues_path(@student.AltID)) 
    else
      render('new')
    end

  end

  def index
    @student = find_student(params[:student_id])
    authorize! :show, @student
    @issues = @student.issues.sorted.select {|r| can? :read, r }
    name_details(@student)    
  end

  def show
    @issue = Issue.find(params[:id])
    authorize! :read, @issue
    @student = Student.find(@issue.students_Bnum)
    name_details (@student)

  end

  def edit

  end

  def update

  end


  private
  def new_issue_params
  #same as using params[:subject] except that:
    #raises an error if :praxis_result is not present
    #allows listed attributes to be mass-assigned
  params.require(:issue).permit(:Name, :Description)
  
  end

  private
  #white lists params for a new update
  def new_update_params
    params.require(:issue).permit(:Name, :Description)
  end

  def close_issue_params
    params.require(:issue_update).permit(:Description)
    
  end

end
