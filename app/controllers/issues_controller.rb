class IssuesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :new
  layout 'application'
  def new
  	@issue = Issue.new

  	@student = find_student(params[:student_id])
    name_details(@student)
  end

  def create
    @student = find_student(params[:student_id])
    name_details(@student)
    @issue = Issue.new(new_issue_params)
    @issue.students_Bnum = @student.Bnum
    @issue.tep_advisors_AdvisorBnum = "123456"    #FIX THIS! fake B# for development only. 

    puts @issue.inspect
    if @issue.save
      flash[:notice] = "New issue opened for: #{@first_name} #{@last_name}"
      redirect_to(student_issues_path(@student.AltID)) 
    else
      render('new')
    end

  end

  def index
    @student = find_student(params[:student_id])
    authorize! :show, @student
    name_details(@student)    
  end

  def show
    @issue = Issue.find(params[:id])
    authorize! :manage, @issue
    @student = Student.find(@issue.students_Bnum)
    name_details (@student)

  end

  def edit

  end

  def update

  end

  def resolve_issue
    #what resources do we need to render this page?
      #student
      #issue

    @issue = Issue.find(params[:issue_id])
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)
    
  end

  def close_issue

    @issue = Issue.find(params[:issue_id])
    @issue.Open = false
    @issue.save

    @update = IssueUpdate.new(close_issue_params)
    @update.UpdateName = "Issue Resolved"
    @update.Issues_IssueID = @issue.IssueID
    @update.tep_advisors_AdvisorBnum = "123456"   #TODO change this to advisor Bnum
    @update.save

    flash[:notice] = "Issue resolved!"

    @student = Student.find(@issue.students_Bnum)
    redirect_to(student_issues_path(@student.AltID))

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
    params.require(:issue_id).permit(:Name, :Description)
  end

  def close_issue_params
    params.require(:issue_update).permit(:Description)
    
  end

end
