class IssuesController < ApplicationController
  def new
  	@issue = Issue.new
  	@student = Student.find(params[:id])
    name_details(@student)
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

    @issue = Issue.find(params[:id])
    @student = Student.find(@issue.students_Bnum)
    name_details(@student)
    
  end

  def close_issue
    
  end

  private
  def new_issue_params

  #same as using params[:subject] except that:
    #raises an error if :praxis_result is not present
    #allows listed attributes to be mass-assigned
  params.require(:issue).permit(:Name, :Description)
  
  end

  private
  def new_update_params
    params.require(:issue_update).permit(:Name, :Description)
  end

end
