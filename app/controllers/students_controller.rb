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
#  ProgStatus       :string(45)       default("Prospective")
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  CurrentMajor2    :string(45)
#  TermMajor        :integer
#  PraxisICohort    :string(45)
#  PraxisIICohort   :string(45)
#  CellPhone        :string(45)
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#
# Indexes
#
#  Bnum_UNIQUE  (Bnum) UNIQUE
#

class StudentsController < ApplicationController
  
  layout 'application'
  # load_and_authorize_resource
  authorize_resource
  def index
    user = current_user
  	@students = Student.all.current.by_last.select {|r| can? :index, r }    #also need to filter for students who are activley enrolled.
  end

  def show
    @student = Student.find params[:id]
    authorize! :show, @student
  end

end
