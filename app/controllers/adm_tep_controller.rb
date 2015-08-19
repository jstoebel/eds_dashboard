class AdmTepController < ApplicationController
  def new
    #display menu for possible names and possible programs


    #UNCOMMENT THIS!!
    # if current_term(exact=true) == nil
    #   flash[:notice] = "No Berea term is currently not in session. You may not add a new studnet to apply."
    #   redirect_to(adm_tep_index_path)
    # end


    @students = Student.where("ProgStatus <> 'Candidate' and EnrollmentStatus='Active Student' and Classification <> 'Senior'")
    @programs = Program.where("Current = 1")

    @app = AdmTep.new
  end

  def create
 

    #UNCOMMENT THIS!!
    # if current_term(exact=true) == nil
    #   flash[:notice] = "No Berea term is currently not in session. You may not add a new studnet to apply."
    #   redirect_to(adm_tep_index_path)
    # end

    @app = AdmTep.new(new_adm_params)
    @current_term = current_term(exact=true)    #we have already validated that we are inside a current term
    @bnum =  params[:adm_tep][:Student_Bnum]
    @prog_code = params[:adm_tep][:Program_ProgCode]

    @app.BannerTerm_BannerTerm =  201415  #TODO go back to this! -> @curent_term.BannerTerm
    @app.AppID = [@bnum, "201415", @prog_code].join('-')   #TODO go back to this! -> @curent_term.BannerTerm

    #TODO fetch GPA,  GPA last 30, earned credits. Add to @app

    if @app.save
      @student = Student.find(@bnum)
      name_details(@student)

      @program = Program.find(@prog_code)

      flash[:notice] = "New application added: #{@first_name}, #{@last_name}, #{@program.EDSProgName}"
      redirect_to(action: 'index')
    else
      flash[:notice] = "Application not saved."
      error_new
      
    end

  end

  def edit
      @application = AdmTep.where("AltID = ?", params[:id]).first
      @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
      @student = Student.find(@application.Student_Bnum)
      name_details(@student)

  end

  def update

    @application = AdmTep.where("AltID = ?", params[:id]).first
    @application.TEPAdmit = params[:adm_tep][:TEPAdmit]

    #if admitted, an admit date must be given
    if params[:adm_tep]["RegDate(1i)"] and params[:adm_tep]["RegDate(2i)"] and params[:adm_tep]["RegDate(3i)"]
        #date given!

            #was it inside the current term?
                #yes
                    #assign date and move on
                #no
                    #raise error
        #date wasn't given
            #raise error

    end



    #validations:

      #needs GPA
      if @application.GPA < 2.75 and @application.GPA < 3.0
          @application.errors.base("Student does not have sufficent GPA to be admitted")
      end

      #needs Praxis pass

      if not praxisI_pass(Student.find(@application.Student_Bnum))
        @application.errors.base("Student must pass the Praxis I exam in order to be admitted.")
      end



      if @application.save
          flash[:notice] = "Student application successfully updated"
          redirect_to(adm_tep_index_path)
      else
          error_update
      end
  end

  def index

    #@current_term: the current term in time
    #@term: the term displayed
    #get the requseted term, or the current term

    @current_term = current_term(exact_term=false)
    if params[:banner_term_id]
      @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412

    else
      @term = @current_term   #if no params passed, the term to render is current term
    end
        
    @applications = AdmTep.all.by_term(@term)   #fetch all applications for this term

    #assemble possible terms for select menu 

    @menu_terms = BannerTerm.joins(:adm_tep).group(:BannerTerm).where("StartDate > ? and StartDate < ?", Date.today-730, Date.today)
    
    if (@current_term) and not (@menu_terms.include? @current_term)
      @menu_terms << @current_term    #add the current term if its not there already.
    end


  end

  def choose
    #display applicants for a term
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_adm_tep_index_path(@term))
    
  end

  def show
  end

  def admit

    #validate student has passed Praxis


    #enter date student was admitted
    
  end


  private
  def new_adm_params
    params.require(:adm_tep).permit(:Student_Bnum, :Program_ProgCode)
  end

  def edit_adm_params
    params.require(:adm_tep).permit(:TEPAdmit, :TEPAdmitDate)
  end

  def error_new
    #sends user back to new form

    @students = Student.where("ProgStatus <> 'Candidate' and EnrollmentStatus='Active Student' and Classification <> 'Senior'")
    @programs = Program.where("Current = 1")
    render('new')
  end

  def error_update
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = Student.find(@application.Student_Bnum)
    name_details(@student)
    render('edit')
    
  end

end