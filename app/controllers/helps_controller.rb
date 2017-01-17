class HelpsController < ApplicationController
  # before_filter :get_articles
  skip_load_and_authorize_resource
  # to add an article here:
    # add the name of the article to article_namess
    # add a .html.md file to app/views/helps. Prepend an `_` to the begning of the file
    # example: _spam.html.md

  # ASSUMPTION. There is always an article called home
  base_path = 'app/views/helps'
  view_path = Rails.root.join(base_path, '**', '*.md')
  contents = Dir[view_path]
  re = Regexp.new(base_path+"/_(?<filebase>.+?).html.md")
  article_names = contents.map {|f| re.match(f)[:filebase] }
  article_names.delete_at(article_names.index('home'))
  article_names.unshift('home')

  article_names.each do |article|
    define_method article do
      @article_names = article_names
      # put home at the top
      get_article_name
      render 'help_layout'
    end
  end


  private
  def get_article_name
    @article_name = "helps/#{params[:action]}"
  end

end
