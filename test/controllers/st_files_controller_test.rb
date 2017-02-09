require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

class StFilesControllerTest < ActionController::TestCase

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
                        adm_st = FactoryGirl.create :accepted_adm_st
                        @st_file = adm_st.st_files.first
                        get :download, :st_file_id => @adm_file.id
                    end

                    test "response" do
                        assert_response :success
                    end

                end # download

                describe "create" do

                    before do
                        @adm_tep = FactoryGirl.create :pending_adm_st
                    end

                    describe "success" do

                        before do
                            post :create, {
                                :adm_st_id => @adm_st.id,
                                :st_file => {
                                    :doc => fixture_file_upload('test_file.txt')
                                }
                            }
                        end

                        test "successful flash message" do
                            assert_equal "File successfully uploaded", flash[:notice]
                        end

                        test "redirects" do
                            assert_redirected_to banner_term_adm_st_index_path(@adm_st.banner_term.id)
                        end
                    end

                    describe "fail, bad params" do

                        test "fails with no doc" do
                            post :create, {
                                :adm_tep_id => @adm_st.id
                            }

                            assert_redirected_to banner_term_adm_st_index_path(@adm_st.banner_term.id)
                            assert_equal "Please provide a file", flash[:notice]
                        end


                    end

                end

                describe "destroy" do

                    before do
                        @adm_st = FactoryGirl.create :accepted_adm_st
                        @st_file  = @adm_st.st_files.first
                        delete :destroy, {:id => @st_file.id}
                    end

                    test "destroys record" do
                        assert @st_file.persisted?
                    end

                    test "redircets" do
                        assert_redirected_to banner_term_adm_st_index_path(@adm_st.banner_term.id)
                    end

                    test "flash message" do
                        assert_equal "Removed file: #{@st_file.student_file.doc_file_name}", flash[:notice]
                    end

                end
            end
        end
    end

    (all_roles - allowed_roles).each do |r|
        puts r
        describe "restricted roles" do
            before do
                load_session(r)
                @adm_st = FactoryGirl.create :accepted_adm_st
                @st_file = @adm_st.adm_files.first
            end

            describe "as #{r}" do
                test "can't get download" do
                    get :download, :st_file_id => @st_file.id
                    assert_redirected_to "/access_denied"
                end

                test "can't post create" do
                    post :create, {
                        :adm_st_id => @adm_st.id,
                        :st_file => {
                            :doc => fixture_file_upload('test_file.txt')
                        }
                    }
                    assert_redirected_to "/access_denied"
                end

                test "can't delete destroy" do
                    delete :destroy, :id => @st_file.id
                    assert_redirected_to "/access_denied"
                end

            end

        end
    end

end
