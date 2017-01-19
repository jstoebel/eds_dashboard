# == Schema Information
#
# Table name: students
#
#  id                      :integer          not null, primary key
#  Bnum                    :string(9)        not null
#  FirstName               :string(45)       not null
#  PreferredFirst          :string(45)
#  MiddleName              :string(45)
#  LastName                :string(45)       not null
#  PrevLast                :string(45)
#  EnrollmentStatus        :string(45)
#  Classification          :string(45)
#  CurrentMajor1           :string(45)
#  concentration1          :string(255)
#  CurrentMajor2           :string(45)
#  concentration2          :string(255)
#  CellPhone               :string(45)
#  CurrentMinors           :string(255)
#  Email                   :string(100)
#  CPO                     :string(45)
#  withdraws               :text(65535)
#  term_graduated          :integer
#  gender                  :string(255)
#  race                    :string(255)
#  hispanic                :boolean
#  term_expl_major         :integer
#  term_major              :integer
#  presumed_status         :string(255)
#  presumed_status_comment :text(65535)
#

class StudentsController < ApplicationController

  layout 'application'
  skip_authorize_resource :only => [:update_presumed_status]
  respond_to :html, :json
  def index
    all_students = Student.all.by_last

    if (params[:all]) == "true"
      @students = all_students.select{|s| can? :read, s}
    elsif (params[:search]).present?
      query = Student.with_name(params[:search])
      @students = all_students.joins(:last_names).where(query).select{|s| can? :read, s}
    else # no params given
      @students = all_students.active_student.current.select{|s| can? :read, s}
    end

    respond_with @students
  end

  def show
    @student = Student.find params[:id]
    authorize! :read, @student
  end

  def update_presumed_status

    @student = Student.find params[:student_id]
    begin
      authorize! :write, @student
    rescue CanCan::AccessDenied => e
      render :json => {:message => e.message}, :status => :unprocessable_entity
      return
    end

    @student.assign_attributes params.require(:student).permit(:presumed_status, :presumed_status_comment)
    if @student.save
      render :json => @student, status: :created
      return
    else
      render :json => {:message => @student.errors.full_messages}, :status => :unprocessable_entity
      return
    end
  end

  def get_resources
    # return json off all of the resources available about this student to
    # this user with counts
    # structure:
    # [
    #   {
    #     menu_name: 'PGPs',  // the name to display in the menu
    #     link_url: '/some/url', // the link
    #     disable: false // if the link should be disabled
    #   }
    # ]

    actions =[]
    student = Student.find params[:student_id]
    if can? :read, student
      actions.push(
        {
          disable: false, menu_name: "Details",
          link_url: student_path(student.AltID)
        }
      )
    else
      actions.push(
        {
          disable: true,
          menu_name: "Details",
          link_url: student_path(student.AltID)
        }
      )
    end

    if can? :be_concerned, student
     actions.push(
        {
          disable: false,
          menu_name: "Checkpoints",
          link_url: student_concern_dashboard_index_path(student.id)
        }
     )

    else
      actions.push(
        {
          disable: true,
          menu_name: "Checkpoints",
          link_url: student_concern_dashboard_index_path(student.id)
        }
      )
    end

    if can? :index, PraxisResult
      actions.push(
        {
          disable: false,
          menu_name: "Praxis Results",
          link_url: student_praxis_results_path(student.AltID)
        }
      )
    else
      actions.push(
        {
          disable: true,
          menu_name: "Praxis Results",
          link_url: student_praxis_results_path(student.AltID)
        }
      )
    end

    if can? :show, Pgp
      actions.push(
        {
          disable: false,
          menu_name: "PGPs (#{student.pgps.size})",
           link_url: student_pgps_path(student.AltID)
        }
      )

    else
      actions.push(
        {
          disable: true,
          menu_name: "PGPs (#{student.pgps.size})",
          link_url: student_pgps_path(student.AltID)
        }
      )
    end

    if can? :show, Issue
      actions.push(
        {
          disable: false,
          menu_name: "Issues (#{student.issues.select{|u| u.visible}.size})",
          link_url: student_issues_path(student.AltID)
        }
      )
    else
      actions.push(
        {
          disable: true,
          menu_name: "Issues (#{student.issues.select{|u| u.visible}.size})",
          link_url: student_issues_path(student.AltID)
        }
      )
    end

    if can? :read, StudentFile
      actions.push(
        {
          disable: false,
          menu_name: "Files (#{student.student_files.active.size})",
          link_url: student_student_files_path(student.AltID)
        }
      )
    else
      actions.push(
        {
          disable: true,
          menu_name: "Files (#{student.student_files.active.size})",
          link_url: student_student_files_path(student.AltID)
        }
      )
    end

    render :json => actions

  end # get_resources

end
