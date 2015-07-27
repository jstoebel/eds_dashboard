class IssuesController < ApplicationController
  def new
  	@issue = Issue.new

    #TODO FIX THIS!
  	# @student = Student.find(@issue.students_Bnum)
   #  name_details(@student)
  end

  def create
    @student = Student.find(params[:id])
    name_details(@student)
    @issue = Issue.new(new_issue_params)
    @issue.students_Bnum = params[:id]
    @issue.tep_advisors_AdvisorBnum = "123456"    #FIX THIS! fake B# for development only. 

    if @issue.valid?
      @issue.save
      flash[:notice] = "New issue opened for: #{@first_name}, #{@last_name}"
      redirect_to(action: 'show', id: params[:id]) 
    else
      render('new')
    end

  end

  def index
    @student = find_student(params[:student_id])
    name_details(@student)    
  end

  def show
    @student = Student.find(params[:id])
    name_details(@student)

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
    @update.tep_advisors_AdvisorBnum = "123456"   #FIX THIS!
    @update.save

    flash[:notice] = "Issue resolved!"
    redirect_to(student_issues_path(@issue.students_Bnum))

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
    params.require(:issue_update).permit(:Name, :Description)
  end

  def close_issue_params
    params.require(:issue_update).permit(:Description)
    
  end

end
