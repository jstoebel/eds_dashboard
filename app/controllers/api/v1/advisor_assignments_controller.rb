module Api
  module V1
    class AdvisorAssignmentsController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def update
        #takes a student id and an array of all of that student's current advisors Bnums.
        # advisor assignments are dropped and created as needed
        # example: {:student_id => 1, :advisors => [{:AdvisorBnum => "B00123456", :Name => "Yoli Carter"}]}

        stu = Student.find params[:student_id]
        current_advisor_bnums = stu.advisor_assignments.map{|aa| aa.tep_advisor.AdvisorBnum}

        new_advisors = (params[:advisors]).present? ? params[:advisors].map{|a| a["AdvisorBnum"]} : [] #if an empty array is passed, it gets parsed into nil

        new_advisor_bnums = new_advisors.map{|adv| adv["AdvisorBnum"]}  # B#s only

        #add_me: who is not in current and IS in new?
        add_me = new_advisors.select{|n| !current_advisor_bnums.include?(n["AdvisorBnum"])} #array of hashes with bnum and name

        # delete me: bnums IN current and NOT in new
        delete_me = current_advisor_bnums.select{|bnum| !new_advisor_bnums.include?(bnum)} # array of just Bnums


        begin
          AdvisorAssignment.transaction do

            delete_me.each{|bnum| destroy_assignment(stu, bnum)}
            
            #add new assignments as well
            add_me.each do |hash|
              advisor = find_or_create_advisor(hash)
              AdvisorAssignment.create({
                  :student_id => stu.id,
                  :tep_advisor_id => advisor.id
                })
            end #each loop
          
          end # transaction

          render :json => {:success => true, :msg => "Successfully altered advisor assignments.", :added => add_me, :deleted => delete_me}, status: :created
        rescue ActiveRecord::RecordNotFound => e
          render :json => {:success => false, :msg => e}, status: :unprocessable_entity

        end # exception handle

      end # create action

      private

      def destroy_assignment(stu, bnum)
        # bnum: B# of tep_advisor
        # stu: student record
        # the advisor is unassigned from this student

        advisor = TepAdvisor.find_or_create_by :AdvisorBnum => bnum

        assignment = AdvisorAssignment.find_by({:tep_advisor_id => advisor.id,
          :student_id => stu.id
          })
        assignment.destroy!
      end

      def find_or_create_advisor(adv_hash)

        # in the unlikly event that between the failed find and creation another process
        # creates a record that conflicts with the one created here.
        # if this happens a retry will happen which will find the record created by the other process

        begin
          advisor = TepAdvisor.find_or_create_by({:AdvisorBnum => adv_hash["AdvisorBnum"], :name => adv_hash["name"]})
        rescue ActiveRecord::RecordInvalid => e
          retry
        end

        return adviso
      end

    end
  end
end