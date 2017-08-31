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
    # display either all issues you have permission to or just issues for a 
    # single student
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
    @dispositions = Disposition.current.ordered
    name_details(@student)
  end

  def create
    @student = Student.find params[:student_id]

    @issue = Issue.new(issue_params)
    @issue.student_id = @student.id

    # assign advisor's B#
    user = current_user
    @issue.tep_advisors_AdvisorBnum = user.tep_advisor.andand.id
    @issue.starting_status = params[:issue_update][:status]
    #make sure user is permitted to create issue for this student
    authorize! :create, @issue

    begin
      Issue.transaction do
        @issue.save!
        p "*"*50
        puts({UpdateName: "Issue opened",
          :Description => "Issue opened",
          :Issues_IssueID => @issue.id,
          tep_advisors_AdvisorBnum: @issue.tep_advisors_AdvisorBnum,
          addressed: false,
          :status => params[:issue_update][:status]
        })
        p "*"*50
        @update = IssueUpdate.create!({:UpdateName => "Issue opened",
          :Description => "Issue opened",
          :Issues_IssueID => @issue.id,
          :tep_advisors_AdvisorBnum => @issue.tep_advisors_AdvisorBnum,
          :addressed => false,
          :status => params[:issue_update][:status]
        })

      end # transaction
      
      flash[:info] = "New issue opened for: #{@student.name_readable}"
      redirect_to(student_issues_path(@student.AltID))
    rescue => e
      
      @dispositions = Disposition.current.ordered
      render('new')
    rescue Net::SMTPAuthenticationError
      # the issue and issue update was saved, but the email wouldn't send
      # everything is secure in the database
      flash[:info] = 'New issue opened for: #{@student.name_readable} '\
      'but there may have been a problem sending email'\
      'alerts. Please contact your administrator if '\
      'problem persists.'
      redirect_to(student_issues_path(@student.id))
    end

  end # action

  def destroy
    # hide records the user but still exist in the database
    @issue = Issue.find(params[:id])
    authorize! :manage, @issue # added after test --> check w/JS #read,write, and manage
    @issue.visible = false
    @issue.save
    flash[:info] = "Deleted Successfully!"
    redirect_to(student_issues_path(@issue.student.id))
  end

  def edit
    @issue = Issue.find params[:id]
    @student = @issue.student
    authorize! :manage, @issue
    @dispositions = Disposition.current.ordered
  end

  def update
    @issue = Issue.find params[:id]
    @issue.assign_attributes issue_params
    @student = @issue.student
    if @issue.save
      flash[:info] = "Issue updated for: #{@student.name_readable}"
      redirect_to(student_issues_path(@student.AltID))
    else
      @dispositions = Disposition.current.ordered
      render 'new'
    end

  end

  private

  def issue_params
    # params safe listing
    params.require(:issue).permit(:Name, :Description, :disposition_id)

  end


end
