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

        add_me = params[:advisors] - current_assignments  #ids of advisors to assign to students
        delete_me = current_assignments - params[:advisors] #ids of advisors to remove from students

        begin
          AdvisorAssignment.transaction do
            delete_me.each{|d| AdvisorAssignment.find(d).destroy!}
            #add new assignments as well
            add_me.each{|a| AdvisorAssignment.create({
                student_id: stu.id,
                :advis
              })
          }
          end
        rescue Exception => e
          render :json => e, status: :unprocessable_entity

        end

      end

      private

      def upsert_assignment
        
        
      end

    end
  end
end