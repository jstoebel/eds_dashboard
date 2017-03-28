class HelpsController < ApplicationController
  skip_load_and_authorize_resource
  # to add an article here:
  # 1) add a .html.md file to app/views/helps. Prepend an `_` to the begning of the file
    # example: _spam.html.md
  # That's it!
  # all help files are found at /help or /help/<file_name>

  def home
    base_path = 'app/views/helps'
    view_path = Rails.root.join(base_path, '**', '*.md')
    contents = Dir[view_path]
    re = Regexp.new(base_path+"/_(?<filebase>.+?).html.md")
    @article_names = contents.map {|f| re.match(f)[:filebase] }
    @article_name = params[:article]
  end

end
