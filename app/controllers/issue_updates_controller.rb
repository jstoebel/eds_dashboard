# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text(65535)      not null
#  Description              :text(65535)      not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  addressed                :boolean
#  status                   :string(255)
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

    @update.tep_advisors_AdvisorBnum = user.tep_advisor.andand.id
    @update.addressed = false # all updates start out as unadressed.
    authorize! :manage, @update

    @student = Student.find(@issue.student.id)
    authorize! :read, @student

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
    @student = Student.find(@issue.student.id)
    authorize! :read, @student
    name_details(@student)
    @updates = @issue.issue_updates.sorted.where(:visible => true).select {|r| can? :read, r }  #no additional auth needed. If you can? the issue you can? the updates
  end

  def destroy
    #should destory records and make them not visible to the user,
    # but still presist in the database
    
    authorize! :read, @manage
    @update = IssueUpdate.find(params[:id])
    @update.visible = false
    @update.save
    flash[:notice] = "Deleted Successfully!"
    redirect_to(issue_issue_updates_path(@update.issue.id))
  end


  def update
    # user may toggle if the issue is addressed attr
    update = IssueUpdate.find params[:id]
    authorize! :manage, update
    update.addressed = params[:issue_update][:addressed]

    response = {:json => update}
    if update.save
      render :json => update, status: :created
    else
      render :json => update, status: :unprocessable_entity
    end

  end

  private
  def close_issue_params
    params.require(:issue_update).permit(:Description)

  end

  def issue_update_params
    params
      .require(:issue_updates)
      .permit(:UpdateName, :Description, :status, :addressed)
  end

end
