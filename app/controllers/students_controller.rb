# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  concentration1   :string(255)
#  CurrentMajor2    :string(45)
#  concentration2   :string(255)
#  CellPhone        :string(45)
#  CurrentMinors    :string(255)
#  Email            :string(100)
#  CPO              :string(45)
#  withdraws        :text(65535)
#  term_graduated   :integer
#  gender           :string(255)
#  race             :string(255)
#  hispanic         :boolean
#  term_expl_major  :integer
#  term_major       :integer
#

class StudentsController < ApplicationController

  layout 'application'
  authorize_resource
  def index
    # display all students requested.
    # possible param :page (the page of display)
    # :search => the name to search for

    page_size = 25

    all_students = Student.all.by_last.active_student

    if (params[:search]).present?
      all_students = all_students.with_name params[:search]
    end

    @page_max = all_students.size / page_size   # max number of pages

    @page_max = 1 if @page_max == 0

    page_param = params[:page].to_i

    if page_param.nil? || page_param < 1
      # nil or negative numbers
      @page_num = 1
    elsif page_param > @page_max
      # larger than the max
      @page_num = @page_max
    else
      # normal bounds
      @page_num = page_param
    end

    # nil -> a previous/next page isn't available (we are at begining/end)
    @prev_page = @page_num>1 ? @page_num-1 : nil
    @next_page = @page_num < @page_max ? @page_num + 1 : nil

    @students = all_students.select{|s| can? :read, s}.slice((@page_num-1)*25, @page_num * 25)


  end

  def show
    @student = Student.find params[:id]
    authorize! :show, @student
  end

end
