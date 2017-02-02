require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

class AdmFilesControllerTest < ActionController::TestCase

    all_roles = Role.all.pluck :RoleName
    allowed_roles = [:admin, :staff]

    describe "allowed roles" do

        allowed_roles.each do |r|

            describe "as #{r}" do
                before do
                    load_session(r)
                end

                describe "download" do
                    before do
                        adm_tep = FactoryGirl.create :accepted_adm_tep
                        @adm_file = adm_tep.adm_files.first
                        get :download, :adm_file_id => @adm_file.id
                    end

                    test "response" do
                        assert_response :success
                    end

                end # download

                describe "create" do

                    before do
                        @adm_tep = FactoryGirl.create :pending_adm_tep
                    end

                    describe "success" do

                        before do
                            post :create, {
                                :adm_tep_id => @adm_tep.id,
                                :adm_file => {
                                    :doc => fixture_file_upload('test_file.txt')
                                }
                            }
                        end

                        test "successful flash message" do
                            assert_equal "File successfully uploaded", flash[:notice]
                        end

                        test "redirects" do
                            assert_redirected_to banner_term_adm_tep_index_path(@adm_tep.banner_term.id)
                        end
                    end

                    describe "fail, bad params" do

                        test "fails with no doc" do
                            post :create, {
                                :adm_tep_id => @adm_tep.id,
                                :adm_file => {
                                    :doc => nil
                                }
                            }

                            assert_redirected_to banner_term_adm_tep_index_path(@adm_tep.banner_term.id)
                            assert_equal "There was a problem uploading your file", flash[:notice]
                        end


                    end

                end

                describe "destroy" do

                    before do
                        @adm_tep = FactoryGirl.create :accepted_adm_tep
                        @adm_file  = @adm_tep.adm_files.first
                        delete :destroy, {:id => @adm_file.id}
                    end

                    test "destroys record" do
                        assert @adm_file.persisted?
                    end

                    test "redircets" do
                        assert_redirected_to banner_term_adm_tep_index_path(@adm_tep.banner_term.id)
                    end

                    test "flash message" do
                        assert_equal "Removed file: #{@adm_file.student_file.doc_file_name}", flash[:notice]
                    end

                end
            end
        end
    end

end
