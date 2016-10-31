# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text(65535)      not null
#  Description              :text(65535)      not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  positive                 :boolean
#  disposition_id           :integer
#

class IssuesController < ApplicationController

  authorize_resource
  skip_authorize_resource :only => :new
  layout 'application'

  def index

    if params[:student_id].present?
      @student = Student.find params[:student_id]
      authorize! :show, @student
      @issues = @student.issues.sorted.visible.select {|r| can? :read, r }
      name_details(@student)
    else
      all_issues = Issue.all.sorted.visible.select {|issue| can? :read, issue}
      @issues = all_issues.select {|issue| issue.open? }
    end

  end

  def new
  	@issue = Issue.new
    @update = IssueUpdate.new
  	@student = Student.find params[:student_id]
    name_details(@student)
  end

  def create

    @student = Student.find params[:student_id]

    @issue = Issue.new(new_issue_params)
    @issue.student_id = @student.id

    #assign advisor's B#
    user = current_user
    @issue.tep_advisors_AdvisorBnum = user.tep_advisor.andand.id
    authorize! :create, @issue   #make sure user is permitted to create issue for this student

    begin
      Issue.transaction do
        @issue.save!
        @update = IssueUpdate.create!({:UpdateName => "Issue opened",
          :Description => "Issue opened",
          :Issues_IssueID => @issue.id,
          :tep_advisors_AdvisorBnum => @issue.tep_advisors_AdvisorBnum,
          :addressed => false,
          :status => params[:issue_update][:status]
        })

      end # transaction
      flash[:notice] = "New issue opened for: #{@student.name_readable}"
      redirect_to(student_issues_path(@student.AltID))
    rescue => e
      render('new')
    end # begin/rescue

  end # action



  #destroy method added to issue controller;
  #should destory records and make them not visible to the user,
  # but still exist in the database
  def destroy
    @issue = Issue.find(params[:id])
    authorize! :manage, @issue # added after test --> check w/JS #read,write, and manage
    @issue.visible = false
    @issue.save
    flash[:notice] = "Deleted Successfully!"
    redirect_to(student_issues_path(@issue.student.id))
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


end
