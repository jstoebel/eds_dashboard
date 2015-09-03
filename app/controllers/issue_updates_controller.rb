class IssueUpdatesController < ApplicationController

  layout 'application'
  
  def new
    @issue = Issue.find(params[:issue_id])
    @update = IssueUpdate.new
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)
  end

  def create
    @issue = Issue.find(params[:issue_id])
    @update = IssueUpdate.new(issue_update_params)
    @update.Issues_IssueID = @issue.IssueID
    @update.tep_advisors_AdvisorBnum = "123456"   #TODO FIX THIS
    @student = Student.find(@issue.students_Bnum)

    if @update.save
      flash[:notice] = "New update added"

      redirect_to(issue_issue_updates_path(@issue.IssueID))
    else
      render('new')
    end

  end

  def index
    @issue = Issue.find(params[:issue_id])
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)
    @updates = @issue.issue_updates.sorted    

  end

  def show
    @update = IssueUpdate.find(params[:id])
    @issue = @update.issue
    @student = @issue.student
    name_details(@student)

  end

  def resolve_issue
    @issue = Issue.find(params[:id])
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)   
  	
  end

  def close_issue
    #TODO do we need error handling?


    @update = IssueUpdate.new(close_issue_params)
    @update.UpdateName = "Issue Resolved"
    @update.Issues_IssueID = @issue.IssueID
    @update.tep_advisors_AdvisorBnum = "123456"   #TODO FIX THIS!

    @update.save

    @issue = Issue.find(params[:id])
    @issue.Open = false
    @issue.save

    flash[:notice] = "Issue resolved!"
    # redirect_to(student_issues_path(@issue.students_Bnum))
    redirect_to({action: "index", id: @issue.students_Bnum})
  	
  end

  private
  def close_issue_params
    params.require(:issue_update).permit(:Description)
    
  end

  def issue_update_params
    # puts "*" * 50
    # puts params
    # puts "*" * 50
    
    params.require(:issue_updates).permit(:UpdateName, :Description)
  end

end