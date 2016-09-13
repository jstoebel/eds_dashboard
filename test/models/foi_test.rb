# == Schema Information
#
# Table name: forms_of_intention
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  date_completing :datetime
#  new_form        :boolean
#  major_id        :integer
#  seek_cert       :boolean
#  eds_only        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class FoiTest < ActiveSupport::TestCase
  
  describe "basic validations" do
  
    foi = Foi.new
    foi.valid?
    foi.attributes.except("id", "created_at", "updated_at").keys.each do |key|
      test "missing #{key}" do
        assert_equal @foi.errors[key.to_sym], ["can't be blank"] 
      end
    end
  
  end
  
  describe "_import_foi" do
    
    before do
      @stu = FactoryGirl.create :student
      
      @row = {"Q1.2_3 - B#" => @stu.Bnum , 
      "Recorded Date" => Date.today.strftime("%m/%d/%Y %I:%M:%S %p"),
      "Q1.3 - Are you completing this form for the first time, or is this form a revision..." => "yes",
      "Q3.1 - Which area do you wish to seek certification in?" => Major.first.name,
      "Q1.4 - Do you intend to seek teacher certification at Berea College?" => "yes", 
      "Q2.1 - Do you intend to seek an Education Studies degree without certification?" => "yes"
      }
    end
    
    test "imports row" do
      assert_difference('Foi.count', 1) do
        Foi._import_foi(@row)
      end
    
    end
    
    # describe "doesn't import row - missing param" do
      
    #   must_have = ["Q1.2_3 - B#", "Recorded Date", "Q3.1 - Which area do you wish to seek certification in?",   ]
    #   must_have.each do |k|
      
    #     test "missing k" do
    #         @row[k] = nil
            
    #     end
      
    #   end
      
    # end
    
  end

end
