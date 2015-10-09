class ProgExitsController < ApplicationController
  def index
  	term_menu_setup
  	@exits = ProgExit.all.by_term(@term)   #fetch all applications for this term

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
    @exit.ExitID = [@exit.Student_Bnum, @exit.Program_ProgCode, @exit.ExitTerm].join("-")

    if @exit.save
      flash[:notice] = "Successfully exited #{name_details(@exit.student)} from #{@exit.program.EDSProgName}. Reason: #{@exit.exit_code.ExitDiscrip}."
      redirect_to prog_exits_path
    else
      new_setup
      render('new')
        
    end

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
    @programs = Student.where(AltID: params[:alt_id]).first.programs
    
    response = {}

    @programs.each do |p|   #build a hash with each program mapped to its id
      response.merge!({ p.ProgCode => p.EDSProgName })
    end

    render :json => response

  end

  private
  def new_exit_params
    params.require(:prog_exit).permit(:Program_ProgCode, :ExitCode_ExitCode, :Details)
  end

  def edit_exit_params
    params.require(:prog_exit).permit(:Details)
  end

  def new_setup
    @students = Student.all.where("ProgStatus=?", "Candidate").by_last    #TODO all candidates with unexited programs
    @programs = []
    @exit_reasons = ExitCode.all
  end

end
