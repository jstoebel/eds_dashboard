require 'test_helper'
class HelpsControllerTest < ActionController::TestCase

  roles = Role.all.pluck :RoleName

  describe "help" do

    roles.each do |r|

      describe "as #{r}" do
        before do
          load_session(r)
          @help_dir = 'app/views/helps'
          @md_path = @help_dir + "/_spam.html.md"
          File.open(@md_path, 'w+') {|f| f.write("sample md file") }
          @contents = Dir[@help_dir + '/**/*.md']
        end

        after do
          File.delete(@md_path)
        end

        test "responds with http 200" do
          get :home
          assert_response :success
        end

        test "gets proper file" do
          re = Regexp.new(@help_dir+"/_(?<filebase>.+?).html.md")
          a_file = re.match(@contents[0])[:filebase]

          get :home, {:article => a_file}
          assert_equal a_file, assigns(:article_name)
        end

        test "grabs all md files" do
          get :home
          assert_equal @contents.size, assigns(:article_names).size
        end

      end
    end

  end

end
