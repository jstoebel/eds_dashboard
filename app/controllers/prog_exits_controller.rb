class ProgExitsController < ApplicationController
  authorize_resource

  def index
    #lists all exits for a paticular term as well as exits needed.
  	term_menu_setup
  	@exits = ProgExit.all.by_term(@term)   #fetch all applications for this term
    @needs_exit = exits_needed    #until we get Banner integration this will return []
  end

  def need_exit
    #indexes programs that need exiting.
    @programs = exits_needed  #gathers applications that need exiting.

  end

  def new
    #create a new exit
    @exit = ProgExit.new
    new_setup
  end

  def create
    #create a new exit.

    #mass assign AltID, program code, exit code, details
    @exit = ProgExit.new(new_exit_params)
    @exit.Student_Bnum = Student.find_by(:AltID => params[:prog_exit][:AltID]).Bnum

    exit_date = params[:prog_exit][:ExitDate]
    if exit_date.present?
      @exit.ExitDate = DateTime.strptime(exit_date, '%m/%d/%Y')
      #get term
      term = current_term({:date => @exit.ExitDate})
      @exit.ExitTerm = term.BannerTerm
    else
      @exit.ExitDate = nil
    end

    recommend_date = params[:prog_exit][:RecommendDate]
    if recommend_date.present?
      @exit.RecommendDate = DateTime.strptime(recommend_date, '%m/%d/%Y')
    else
      @exit.RecommendDate = nil
    end

    #TODO CHANGE THIS! compute GPA and GPA_last60
    @exit.GPA = 2.5
    @exit.GPA_last60 = 3.0

    #get exit ID
  
    if @exit.save
      flash[:notice] = "Successfully exited #{name_details(@exit.student)} from #{@exit.program.EDSProgName}. Reason: #{@exit.exit_code.ExitDiscrip}."
      redirect_to prog_exits_path
    else
      new_setup
      render('new')
        
    end

  end

  def new_specific
    #enter a new exit with student's name and program pre populated
    
    @exit = ProgExit.new
    alt_id = params[:prog_exit_id]
    stu = Student.find_by(:AltID => alt_id)
    @exit.Student_Bnum = stu.Bnum
    
    program = params[:program_id]
    @exit.Program_ProgCode = program
    new_setup

  end


  def edit
    @exit = ProgExit.find_by(:AltID => params[:id]) 
  end

  def update
    #update exit record
    @exit = ProgExit.find_by(:AltID => params[:id]) 
    @exit.assign_attributes(edit_exit_params)

    recommend_date = params[:prog_exit][:RecommendDate]
    if recommend_date.present?
      @exit.RecommendDate = DateTime.strptime(recommend_date, '%m/%d/%Y')
    else
      @exit.RecommendDate = nil
    end

    if @exit.save
      flash[:notice] = "Edited exit record for #{name_details(@exit.student)}"
      redirect_to prog_exits_path
    else
      render('edit')
      
    end

  end

  def choose
    #display exits for a new term.
	  @term = params[:banner_term][:menu_terms]
	  redirect_to(banner_term_prog_exits_path(@term))
  end

  def get_programs
    #gets programs for a given student's B#, respond with json of all of students opened programs 

    student = Student.where(AltID: params[:alt_id]).first
    open_admissions = AdmTep.open(student.Bnum)
    open_programs = open_admissions.map { |i| i.program }

    response = {}

    open_programs.each do |p|   #build a hash with each program mapped to its id
      response.merge!({ p.ProgCode => p.EDSProgName })
    end

    render :json => response

  end

  #PRIVATE METHODS
  private
  def new_exit_params
    params.require(:prog_exit).permit(:Student_Bnum, :Program_ProgCode, :ExitCode_ExitCode, :Details)
  end

  def edit_exit_params
    params.require(:prog_exit).permit(:Details)
  end

  def new_setup
    @students = Student.all.where("ProgStatus in (?, ?)", "Candidate", "Completer").by_last    #TODO all candidates with unexited programs
    @programs = []
    @exit_reasons = ExitCode.all
  end

  def exits_needed
    #pre: nothing
    #post:
      #programs: program admissions belonging to: students who have a non
      # TEP major. 

    programs = []

    #1)TODO grab students with no TEP major. We need Banner integration for this.

    #TODO for later
    #add non exiting program admissions belonging to candidates who have graduated 
    
    return programs

  end

end
