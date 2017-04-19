require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

class AdmFilesControllerTest < ActionController::TestCase

    all_roles = Role.all.pluck :RoleName
    allowed_roles = ["admin", "staff"]

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
                        get :download, params: {:adm_file_id => @adm_file.id}
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
                            post :create, params: {
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
                            post :create, params: {
                                :adm_tep_id => @adm_tep.id
                            }

                            assert_redirected_to banner_term_adm_tep_index_path(@adm_tep.banner_term.id)
                            assert_equal "Please provide a file", flash[:notice]
                        end


                    end

                end

                describe "destroy" do

                    before do
                        @adm_tep = FactoryGirl.create :accepted_adm_tep
                        @adm_file  = @adm_tep.adm_files.first
                        delete :destroy, params: {:id => @adm_file.id}
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

    (all_roles - allowed_roles).each do |r|
        describe "restricted roles" do
            before do
                load_session(r)
                @adm_tep = FactoryGirl.create :accepted_adm_tep
                @adm_file = @adm_tep.adm_files.first
            end

            describe "as #{r}" do
                test "can't get download" do
                    get :download, params: { :adm_file_id => @adm_file.id}
                    assert_redirected_to "/access_denied"
                end

                test "can't post create" do
                    post :create, params: {
                        :adm_tep_id => @adm_tep.id,
                        :adm_file => {
                            :doc => fixture_file_upload('test_file.txt')
                        }
                    }
                    assert_redirected_to "/access_denied"
                end

                test "can't delete destroy" do
                    delete :destroy, params: {:id => @adm_file.id}
                    assert_redirected_to "/access_denied"
                end

            end

        end
    end

end
