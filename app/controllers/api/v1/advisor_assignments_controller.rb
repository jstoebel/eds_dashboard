module Api
  module V1
    class AdvisorAssignmentsController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def create
        #takes a student id and an array of all of that student's current advisors Bnums.
        # advisor assignments are dropped and created as needed
        # example: {:student_id => 1, :advisors => ["B00123456", "B00789123"]}

        stu = Student.find params[:student_id]
        current_advisor_bnums = stu.advisor_assignments.map{|aa| aa.tep_advisor.AdvisorBnum}

        add_me = params[:advisors] - current_advisor_bnums  #Bnums of advisors to assign to students
        delete_me = current_advisor_bnums - params[:advisors] #Bnums of advisors to remove from students

        begin
          AdvisorAssignment.transaction do

            delete_me.each{|bnum| destroy_assignment(stu, bnum)}
            
            #add new assignments as well
            add_me.each do |a|
              advisor = find_or_create_advisor(a)
              AdvisorAssignment.create({
                  :student_id => stu.id,
                  :tep_advisor_id => advisor.id
                })
            end #each loop
          
          end # transaction
        rescue Exception => e
          render :json => {:msg => e.to_s}, status: :unprocessable_entity

        end # exception handle

      end # create action

      private

      def destroy_assignment(stu, bnum)
        # bnum: B# of tep_advisor
        # stu: student record
        # the advisor is unassigned from this student

        advisor = TepAdvisor.find_by :AdvisorBnum => bnum
        assignment = AdvisorAssignment.find_by({:tep_advisor_id => advisor.id,
          :student_id => stu.id
          })
        assignment.destroy!
      end

      def find_or_create_advisor(bnum)

        # in the unlikly event that between the failed find and creation another process
        # creates a record that conflicts with the one created here.
        # if this happens a retry will happen which will find the record created by the new process

        begin
          advisor = TepAdvisor.find_or_create_by({:AdvisorBnum => bnum})
        rescue ActiveRecord::RecordInvalid => e
          retry
        end

        return advisor
      end

    end
  end
end