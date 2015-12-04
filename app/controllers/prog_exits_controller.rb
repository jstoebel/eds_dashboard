class ProgExitsController < ApplicationController
  load_and_authorize_resource
  def index
  	term_menu_setup
  	@exits = ProgExit.all.by_term(@term)   #fetch all applications for this term
    @needs_exit = exits_needed
  end

  def need_exit
    @programs = exits_needed  #gathers applications that need exiting.

  end

  def show
  end

  def new
    @exit = ProgExit.new
    new_setup
  end

  def create
    
    #mass assign bnum, program code, exit code, details
    @exit = ProgExit.new(new_exit_params)
    student = Student.from_alt_id(params[:prog_exit][:Student_Bnum])
    if student.kind_of?(Student)
      @exit.Student_Bnum = student.Bnum
    end

    exit_date = params[:prog_exit][:ExitDate]
    if exit_date != ""
      @exit.ExitDate = DateTime.strptime(exit_date, '%m/%d/%Y')
      #get term
      term = current_term({:date => @exit.ExitDate})
      @exit.ExitTerm = term.BannerTerm
    else
      @exit.ExitDate = nil
    end

    recommend_date = params[:prog_exit][:RecommendDate]
    if recommend_date != ""
      @exit.RecommendDate = DateTime.strptime(recommend_date, '%m/%d/%Y')
    else
      @exit.RecommendDate = nil
    end

    #TODO compute GPA and GPA_last60
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
    student = Student.from_alt_id(alt_id)
    @exit.Student_Bnum = student.Bnum
    
    program = params[:program_id]
    @exit.Program_ProgCode = program
    new_setup

  end


  def edit
    @exit = ProgExit.where("AltID=?", params[:id]).first 
  end

  def update
    @exit = ProgExit.where("AltID=?", params[:id]).first    
    @exit.assign_attributes(edit_exit_params)

    recommend_date = params[:prog_exit][:RecommendDate]
    if recommend_date != ""
      @exit.RecommendDate = DateTime.strptime(recommend_date, '%m/%d/%Y')
    else
      @exit.RecommendDate = nil
    end

    if @exit.save
      flash[:notice] = "Edited exited record for #{name_details(@exit.student)}"
      redirect_to prog_exits_path
    else
      render('edit')
      
    end

  end

  def choose
	  @term = params[:banner_term][:menu_terms]
	  redirect_to(banner_term_prog_exits_path(@term))
  end

  def get_programs
    #gets programs for a given student's B#
    # @programs = Student.where(AltID: params[:alt_id]).first.programs
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
    params.require(:prog_exit).permit(:Program_ProgCode, :ExitCode_ExitCode, :Details)
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
    #index all students who need exiting for any of the following 
    #reasons. Student is a candidate and...
      #...graduated
      #...does not have a TEP major
    #or a completer with any open programs

      programs = []

      #graduated but a candidate
      graduated = Student.where("EnrollmentStatus=? and ProgStatus=?", 'Graduation', 'Candidate')
      graduated.each do |s|
        open_programs = AdmTep.open(s.Bnum)   #add all open programs
        programs += open_programs
      end

      #TODO grab students with no TEP major
      
      #any open programs belonging to a completer.

      join_statement = %q(
      JOIN (
      (SELECT `adm_tep`.* 
        FROM `adm_tep` 
        LEFT JOIN prog_exits ON (adm_tep.Program_ProgCode = prog_exits.Program_ProgCode) 
        and (adm_tep.Student_Bnum = prog_exits.Student_Bnum) 
      
        WHERE (prog_exits.id IS NULL AND adm_tep.TEPAdmit = 1 )) as open_prog
    ) ON students.Bnum = open_prog.Student_Bnum
)
      completers = Student.joins(join_statement).where(ProgStatus: 'Completer')

      completers.each do |c|
        open_programs = AdmTep.open(c.Bnum)
        programs += open_programs
      end

    return programs

  end

end
