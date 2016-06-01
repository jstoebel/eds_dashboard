module Api
  module V1

    class StudentsController < ApplicationController
      protect_from_forgery with: :null_session
      # http_basic_authenticate_with name: "spam", password: "eggs"
      respond_to :json

      def index
        respond_with Student.all
      end

      def show
        respond_with Student.find(params[:id])
      end

      def create
        #create a new student based on params
        @student = Student.new params[:student]

        puts "******"
        puts params[:student]
        puts @student.inspect
        puts "******"
        1/0
        # respond_with @student
      end

      def update

      end

      private

      def new_params

        #TODO: need to add attributes to model before this can be completed. See Wiki in banner-updater
        params.require(:student).permit(:Bnum, :FirstName, :MiddleName, :LastName, :EnrollmentStatus, :Classification)
      end

    end

  end
end