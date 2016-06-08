module Api
  module V1

    class StudentsController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        @students = Student.all
        respond_with @students 
      end

      def show
        respond_with Student.find(params[:id])
      end

      def batch_create
        #create new students based on params
        white_listed = params[:students].map{|stu| new_params(stu)}  #a white listed array of params 
        result = Student.batch_create(white_listed)
        if result[:success]
          render json: result, status: :created
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def batch_update

        white_listed = params[:students].map{|stu| update_params(stu)}
        result = Student.batch_update(white_listed)
        if result[:success]
          render json: result, status: :ok
        else
          render json: result, status: :unprocessable_entity
        end

      end

      private

      def new_params(stu)
        stu.permit(:Bnum, :FirstName, :MiddleName, :LastName, 
          :EnrollmentStatus, :Classification, 
          :CurrentMajor1, :concentration1, :CurrentMajor2, :concentration2,
          :TermMajor, :CurrentMinors, :Email, :CPO, :withdrawals, :term_graduated,
          :gender, :race, :hispanic, :term_expl_major, :term_major)
      end

      def update_params(stu)
        stu.permit(:id, :EnrollmentStatus, :Classification, :CurrentMajor1, 
          :concentration1, :CurrentMajor2, :concentration2, :CurrentMinors, 
          :Email, :CPO, :withdrawals, :term_graduated, 
          :gender, :race, :hispanic, 
          :term_expl_major, :term_major)
      end

    end

  end
end