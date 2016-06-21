module Api
  module V1
    class PraxisResultsController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def upsert
        # upserts a single praxis_result record
        # if the record exists, update it
        # otherwise insert it

        #expected params
        # bnum: a valid bnum in banner. Does not necciarily exist in the app
        # praxis_result
          # test_code
          # test_date format (YYYY-MM-DD)
          # test_score 
        
        #get the student
        begin
          bnum = params["bnum"]
          stu = Student.find_by!({:Bnum => bnum})
        rescue ActiveRecord::RecordNotFound => e
          # a valid banner bnum was given but we couln't find the student in this db -> give up!
          render :json => {:success => false, :msg => "Could not find student with Bnum=#{bnum}"}, status: :unprocessable_entity
          return
        end

        # get the test
        begin
          p "*"*50
          puts params["praxis_result"]["TestCode"]
          test_code = params["praxis_result"]["TestCode"]
          praxis_test = PraxisTest.find_by!({:TestCode => test_code})
        rescue ActiveRecord::RecordNotFound => e
            render :json => {:success => false, :msg => "Could not find praxis test with TestCode=#{TestCode}"}, status: :unprocessable_entity
            return
        end

        begin
          
          result_params = {
            :student_id => stu.id,
            :praxis_test_id => praxis_test.id,
            }.merge upsert_params
            
          result = PraxisResult.find_or_initialize_by(result_params)

          result.update_attributes!({
              :test_score => params["test_score"]  
            })

          render :json => {:success => true, :msg => "Successfully upserted praxis result: #{result.inspect}"}, status: :created

        rescue ActiveRecord::RecordInvalid => e
          render :json => {:success => false, :msg => e.message}, status: :unprocessable_entity
        end

      end

      private
      def upsert_params
        params.require(:praxis_result).permit(:test_date, :test_score, :cut_score)
        
      end

    end
  end
end