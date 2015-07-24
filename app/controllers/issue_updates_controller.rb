class IssueUpdatesController < ApplicationController
  def new
  end

  def create
  end

  def index
    @issue = Issue.find(params[:issue_id])
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)
    @updates = @issue.issue_updates    

    
  end

  def show
  end

  def resolve_issue
    @issue = Issue.find(params[:id])
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)   
  	
  end

  def close_issue
    @issue = Issue.find(params[:id])
    @issue.Open = false
    @issue.save

    @update = IssueUpdate.new(close_issue_params)
    @update.UpdateName = "Issue Resolved"
    @update.Issues_IssueID = @issue.IssueID
    @update.tep_advisors_AdvisorBnum = "123456"   #FIX THIS!
    @update.save

    flash[:notice] = "Issue resolved!"
    # redirect_to(student_issues_path(@issue.students_Bnum))
    redirect_to({action: "index", id: @issue.students_Bnum})
  	
  end

  private
  def close_issue_params
    params.require(:issue_update).permit(:Description)
    
  end
end