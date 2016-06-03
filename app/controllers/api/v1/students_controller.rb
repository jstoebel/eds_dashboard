module Api
  module V1

    class StudentsController < ApplicationController
      protect_from_forgery with: :null_session
      # http_basic_authenticate_with name: "spam", password: "eggs"
      respond_to :json

      def api_index
        puts "api controller!"
        @students = Student.all
        respond_with @students 
      end

      def show
        respond_with Student.find(params[:id])
      end

      def create
        #create new students based on params
        white_listed = params[:students].map{|stu| new_params(stu)}  #a white listed array of params 
        result = Student.batch_create(white_listed)
        puts result[:msg]
        if result[:success]
          render json: result, status: :created
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def update

        @student = Student.find params[:id]

        was_cert = @student.has_cert_concentration?

        was_eds = @student.is_eds_major?

        @student.assign_attributes update_params
        @student.PrevLast = @student.LastName_was if @student.LastName_changed? #register prior last name if changed

        if @student.EnrollmentStatus.include?("Dismissed")
          #TODO: logic if student has left the college
            # 1: exit(s) needed if candidate
            # what else
        end

        
        if was_eds and !@student.is_eds_major?
          #logic if student doesn't have EDS
        end

        if was_cert and !@student.has_cert_concentration?
          #logic if student doesn't have cert concentration
        end

        respond_with @student

      end

      private

      def new_params(stu)
        stu.permit(:Bnum, :FirstName, :MiddleName, :LastName, 
          :EnrollmentStatus, :Classification, 
          :CurrentMajor1, :concentration1, :CurrentMajor2, :concentration2,
          :TermMajor, :CurrentMinors, :Email, :CPO, :withdrawals, :term_graduated,
          :gender, :race, :hispanic, :term_expl_major, :term_major)
      end

      def update_params
        params.require(:student).permit(:EnrollmentStatus, :Classification, :CurrentMajor1, 
          :concentration1, :CurrentMajor2, :concentration2, :CurrentMinors, 
          :Email, :CPO, :withdrawals, :term_graduated, 
          :gender, :race, :hispanic, 
          :term_expl_major, :term_major)
      end

    end

  end
end