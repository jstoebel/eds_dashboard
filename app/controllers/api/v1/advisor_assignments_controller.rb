module Api
  module V1
    class AdvisorAssignmentsController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def diff
        #takes a student id and an array of all of that student's current advisors. advisor assignments are dropped and created as needed
        #example: {:student_id => 1, :advisors => [1,2,3]}


        stu = Student.find params[:student_id]
        current_assignments = stu.advisor_assignments.map{|aa| aa.id}

        add_me = params[:advisors] - current_assignments
        delete_me = current_assignments - params[:advisors]

        begin
          AdvisorAssignment.transaction do
            delete_me.each{|d| d.destroy!}
            #add new assignments as well
            # add_me.each{|a| }
          end
        rescue Exception => e
          render :json => e, status: :unprocessable_entity

        end

      end

    end
  end
end