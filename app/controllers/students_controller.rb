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
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#  withdrawals      :text
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
    user = current_user
  	@students = Student.all.by_last.current.select {|r| can? :index, r }    #also need to filter for students who are activley enrolled.
  end

  def show
    @student = Student.find params[:id]
    authorize! :show, @student
  end

end
