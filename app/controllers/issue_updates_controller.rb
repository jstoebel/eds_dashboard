# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text             not null
#  Description              :text             not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

class IssueUpdatesController < ApplicationController
  authorize_resource
  layout 'application'

  
  def new
    #sets up creation of a new issue update
    @issue = Issue.find(params[:issue_id])
    authorize! :manage, @issue

    @student = Student.find(@issue.student.id)
    authorize! :read, @student

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

    @student = Student.find(@issue.student.id)
    authorize! :read, @student

    #change status of issue
    if params[:issue_updates][:issue][:status] == "Closed"
      status = false
    elsif params[:issue_updates][:issue][:status] == "Open"
      status = true
    end

    @issue.Open = status

    if @update.save and @issue.save
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

    @student = Student.find(@issue.student.id)
    authorize! :read, @student

    name_details(@student)

    @updates = @issue.issue_updates.sorted    #no additional auth needed. If you can? the issue you can? the updates

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

  private
  def close_issue_params
    params.require(:issue_update).permit(:Description)
    
  end

  def issue_update_params
    params.require(:issue_updates).permit(:UpdateName, :Description)
  end

end
