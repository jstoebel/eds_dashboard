# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text(65535)
#

class ProgExitsController < ApplicationController
  authorize_resource

  def index
    #lists all exits for a paticular term as well as exits needed.
    term_menu_setup(controller_name.singularize.to_sym, :ExitTerm)

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

    # safe mass assign AltID, program code, exit code, details
    @exit = ProgExit.new(new_exit_params)

    # model will find the exit date and GPAs on its own

    if @exit.save
      flash[:notice] = "Successfully exited #{@exit.student.name_readable} from #{@exit.program.EDSProgName}. Reason: #{@exit.exit_code.ExitDiscrip}."
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
    stu = Student.find alt_id
    @exit.student_id = stu.id

    program = params[:program_id]
    @exit.Program_ProgCode = program
    new_setup

  end


  def edit
    @exit = ProgExit.find params[:id]
  end

  def update
    #update exit record
    @exit = ProgExit.find params[:id]
    @exit.assign_attributes(edit_exit_params)

    if @exit.save
      flash[:notice] = "Edited exit record for #{name_details(@exit.student)}"
      redirect_to banner_term_prog_exits_path(@exit.banner_term.id)
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
    # TODO: move this method to the programs controller. just makes more sense
    # handle's populating a students potential programs to exit via an ajax request
    #gets programs for a given student's id, respond with json of all of students opened programs

    stu = Student.find params[:id]
    open_admissions = stu.open_programs
    open_programs = open_admissions.map { |i| i.program }

    response = {}

    open_programs.each do |p|   #build a hash with each program mapped to its id
      response.merge!({ p.id => p.EDSProgName })
    end

    render :json => response

  end

  private
  def new_exit_params
    params
      .require(:prog_exit)
      .permit(
        :student_id, :Program_ProgCode, :ExitCode_ExitCode, :Details, :ExitDate, 
        :RecommendDate
      )
  end

  def edit_exit_params
    params.require(:prog_exit).permit(:Details, :RecommendDate)
  end

  def new_setup
    # set up a new form
    @students = Student.all.select {|s| s.prog_status == "Candidate"}
    # @students = Student.all.where("ProgStatus in (?, ?)", "Candidate", "Completer").by_last    #TODO all candidates with unexited programs
    @programs = []
    @exit_reasons = ExitCode.all
  end

  def exits_needed
    #pre: nothing
    #post: all students who need to be exited

    programs = []

    #1)TODO grab students with no TEP major. We need Banner integration for this.

    #TODO for later
    #add non exiting program admissions belonging to candidates who have graduated

    return programs

  end

end
