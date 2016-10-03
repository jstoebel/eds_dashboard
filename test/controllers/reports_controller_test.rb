require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "staff"]
  all_roles = Role.all.map {|i| i.RoleName}.to_a
  describe "index" do

    describe "authorized" do

      allowed_roles.each do |r|

        before do

          load_session(r)

          ["227", "228", "440", "479"].each do |code|
            course = FactoryGirl.create :transcript, {:course_code => "EDS#{code}",
              :grade_pt => 3.0
            }
          end

          @stus = Student.all

          get :index

        end

        test "http 200" do
          assert_response :success
        end

        describe "pulls records" do

          test "basic info matches" do
            # Bnum though Minors is correct for each record
            expected_data = assigns(:data)

            # [:Bnum, ]

            expected_data.each_with_index do |val, idx|
              expected_hash = expected_data[idx]
              actual_stu = @stus[idx]

              attrs = [:Bnum, :name_readable, :prog_status, :CurrentMajor1,
              :concentration1, :CurrentMajor2, :concentration2, :CurrentMinors]

              attrs.each do |attr|
                # assure each attribute for expected_hash matches actual_stu
                assert_equal expected_hash[attr], actual_stu.send(attr)
              end

            end # loop

          end


          describe "taken 227_228" do

            courses = ["227", "228", "101"]
            courses.each do |val|

              test "with course EDS#{val}" do
                course = FactoryGirl.create :transcript, {:course_code => "EDS#{val}",
                :grade_pt => 3.0
              }
                stu = course.student

                get :index

                expected_data = assigns(:data)

                expected_data.each do |stu_hash|
                  if stu.Bnum == stu_hash[:Bnum]  # find student in array of hashes
                    assert_equal stu.transcripts.where(:course_code => ["EDS227", "EDS228"]).any?, stu_hash[:Taken227_228]
                  end
                end
              end

          end

          # tests for term_taken 227 and term taken 228
          describe "term completing course" do

            ["227", "228"].each do |context|

              describe "context: #{context}" do

                  courses = [context, "101"]
                  courses.each do |course|
                    test "with #{course}" do
                      course = FactoryGirl.create :transcript, {:course_code => "EDS#{context}",
                      :grade_pt => 3.0
                      }
                      stu = course.student

                      get :index

                      expected_data = assigns(:data)

                      expected_data.each do |stu_hash|
                        if stu.Bnum == stu_hash[:Bnum] # find student in array of hashes


                          expected_term_taken = stu.transcripts
                            .where(:course_code => ["EDS#{context}"])
                            .order(:term_taken).last.banner_term.readable

                          actual_term_taken = stu_hash["Latest_Completion_#{context}".to_sym]

                          assert_equal expected_term_taken, actual_term_taken
                        end
                      end
                    end
                  end
                end
              end
            end

            # tests for term taken 440/479
            describe "context: 440_479" do

              ["440", "479", "101"].each do |course_code|

                test "with #{course_code}" do
                  course = FactoryGirl.create :transcript, {:course_code => "EDS#{course_code}",
                  :grade_pt => 3.0
                  }
                  stu = course.student

                  get :index

                  expected_data = assigns(:data)

                  expected_data.each do |stu_hash|
                    if stu.Bnum == stu_hash[:Bnum] # find student in array of hashes

                      expected_term_taken = stu.transcripts
                        .where(:course_code => ["EDS440", "EDS479"])
                        .order(:term_taken).last.andand.banner_term.andand.readable

                      actual_term_taken = stu_hash[:Latest_Term_EDS440_479]

                      assert_equal expected_term_taken, actual_term_taken
                    end
                  end
                end
              end
            end

          end
        end
      end # each loop

    end # describe authorized

    describe "not authorized" do

      (all_roles - allowed_roles).each do |r|

        describe "as #{r}" do

          before do
            load_session(r)

            get :index
          end

          test "reirected to access_denied" do
            assert_redirected_to "/access_denied"
          end

        end
        
        # tests for term taken 150
        describe "context: EDS150" do  
          
          ["150", "101"].each do |course_code|

            test "with #{course_code}" do
              course = FactoryGirl.create :transcript, {:course_code => "EDS#{course_code}",
              :grade_pt => 3.0
              }
              stu = course.student
              
              get :index
              
              expected_data = assigns(:data)
              
              expected_data.each do |stu_hash|
                if stu.Bnum == stu_hash[:Bnum] # find student in array of hashes
                  expected_term_taken = stu.transcripts
                    .where(:course_code => ["EDS150"])
                    .order(:term_taken).last.andand.banner_term.andand.readable
                    
                  actual_term_taken = stu_hash[:Latest_Term_EDS150]
 
                  assert_equal expected_term_taken, actual_term_taken 
                end
              end
            end
          end
        end
      end
        # tests for student program
        describe "context: Student Program" do
            test "no associated programs" do
              student = FactoryGirl.create :student
              get :index
              
              expected_data = assigns(:data)
              
              expected_data.each do |stu_hash|
                if student.Bnum == stu_hash[:Bnum]
                  expected_program = student.programs.map{|t| "#{t.EDSProgName}"}.join("; ")
                
                actual_program = stu_hash[:ProgName]
                
                assert_equal expected_program, actual_program
                end
              end
            end
          end
            
            
            test "one assocaited program" do
              student = FactoryGirl.create :admitted_student
              get :index
              
              expected_data = assigns(:data)
              
              expected_data.each do |stu_hash|
                if student.Bnum == stu_hash[:Bnum]
                  expected_program = student.programs.map{|t| "#{t.EDSProgName}"}.join("; ")
                  
                actual_program = stu_hash[:ProgName]
                
                assert_equal expected_program, actual_program
                end
              end
            end
            
            test "two associated programs" do
              student = FactoryGirl.create :admitted_student
              admit_term = student.transcripts.first.banner_term.next_term
              FactoryGirl.create :adm_tep, 
              {
                :program => Program.second,
                :TEPAdmitDate => admit_term.StartDate,
                :BannerTerm_BannerTerm => admit_term.id, 
                :student_id => student.id
              }
                
                
              get :index
              
              expected_data = assigns(:data)
              
              expected_data.each do |stu_hash|
                if student.Bnum == stu_hash[:Bnum]
                  expected_program = student.programs.map{|t| "#{t.EDSProgName}"}.join("; ")
                  
                actual_program = stu_hash[:ProgName]
                
                assert_equal expected_program, actual_program
                end
              end
            end
          
          
        end
    
    
    end

  end
end
