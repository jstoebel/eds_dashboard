# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text             not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

class IssuesController < ApplicationController
 
  authorize_resource
  skip_authorize_resource :only => :new
  layout 'application'

  def new
  	@issue = Issue.new
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

    if @issue.save
      flash[:notice] = "New issue opened for: #{name_details(@student)}"
      redirect_to(student_issues_path(@student.AltID)) 
    else
      render('new')
    end

  end

  def index
    @student = Student.find params[:student_id]
    authorize! :show, @student
    @issues = @student.issues.sorted.select {|r| can? :read, r }
    name_details(@student)    
  end

  def show
    @issue = Issue.find(params[:id])
    authorize! :read, @issue
    @student = Student.find(@issue.student_id)
    name_details (@student)

  end

  def edit

  end
  
  #destroy method added to issue controller; 
  #should destory records and make them not visible to the user, 
  # but still exist in the database
  def destroy 
    @issue = Issue.find(params[:id])
    @issue.visible = false
    @issue.save
    flash[:notice] = "Deleted Successfully!"
    redirect_to(student_issues_path(@student.Issue))
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
