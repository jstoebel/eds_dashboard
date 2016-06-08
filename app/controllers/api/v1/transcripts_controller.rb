module Api
  module V1
  	class TranscriptsController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def batch_upsert
        #upsert course info based on params
        white_listed = params[:transcripts].map{|course| preped_params(course)}  #a white listed array of params 
        result = Transcript.batch_upsert(white_listed)
        if result[:success]
          render json: result, status: :created
        else
          render json: result, status: :unprocessable_entity
        end
      end

      private

      def preped_params(course)
      	#handles preping a hash representing a single course
      	cleaned = cleaned_params(course)
      	stu = Student.find_by :Bnum => course[:Bnum]
      	cleaned[:student_id] = stu.andand.id
      	return cleaned
      end

      def cleaned_params(course)
      	return course.permit(:crn, :course_code, :course_name, :term_taken, 
      		:grade_pt, :grade_ltr, :quality_points, :credits_attempted, :credits_earned,
      		:reg_status, :Inst_bnum, :gpa_include)
      end

  	end
  end
end