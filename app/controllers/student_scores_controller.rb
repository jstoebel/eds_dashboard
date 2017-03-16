class StudentScoresController < ApplicationController

  def index

    @format_types = [:moodle, :qualtrics]
    # upload a student score


  end

  def import
    # process a file
    file = params[:file]
    file_format = params[:format]

    byebug
    # process the file. Should return an array containing results of
    # processing each record


  end

end
