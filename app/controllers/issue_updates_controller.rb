class IssueUpdatesController < ApplicationController
  authorize_resource
  layout 'application'
  
  def new
    #sets up creation of a new issue update
    @issue = Issue.find(params[:issue_id])
    authorize! :manage, @issue

    @student = Student.find(@issue.students_Bnum)
    authorize! :manage, @student

    @update = IssueUpdate.new

    name_details(@student)

  end

  def create
    #saves a new update to the database, redirects to index if successful, rerenders page if error.
    @issue = Issue.find(params[:issue_id])

    @update = IssueUpdate.new(issue_update_params)
    @update.Issues_IssueID = @issue.IssueID

    #assign advisor's B#
    user = current_user
    @update.tep_advisors_AdvisorBnum = user.tep_advisor.AdvisorBnum 
    authorize! :manage, @update

    @student = Student.find(@issue.students_Bnum)
    authorize! :manage, @student

    if @update.save
      flash[:notice] = "New update added"

      redirect_to(issue_issue_updates_path(@issue.IssueID))
    else
      render('new')
    end

  end

  def index
    #indexes updates for parent issue
    @issue = Issue.find(params[:issue_id])
    authorize! :read, @issue

    @student = Student.find(@issue.students_Bnum)
    authorize! :read, @student

    name_details(@student)

    @updates = @issue.issue_updates.sorted.select {|r| can? :read, r }    

  end

  def show
    #shows info on this issue update
    #TODO implement as a popover
    @update = IssueUpdate.find(params[:id])
    @issue = @update.issue
    authorize! :read, @issue

    @student = @issue.student
    authorize! :read, @student

    name_details(@student)

  end

  def resolve_issue
    #begins disalogue 
    @issue = Issue.find(params[:id])
    authorize! :manage, @issue

    @student = Student.find(@issue.students_Bnum)
    authorize! :manage, @student

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