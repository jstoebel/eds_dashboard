class StudentScoreUploadsController < ApplicationController
  before_action :set_student_score_upload, only: [:show, :edit, :update, :destroy]

  # GET /student_score_uploads
  # GET /student_score_uploads.json
  def index
    @student_score_uploads = StudentScoreUpload.all
  end

  # GET /student_score_uploads/1
  # GET /student_score_uploads/1.json
  def show
  end

  # GET /student_score_uploads/new
  def new
    @student_score_upload = StudentScoreUpload.new
  end

  # GET /student_score_uploads/1/edit
  def edit
  end

  # POST /student_score_uploads
  # POST /student_score_uploads.json
  def create
    @student_score_upload = StudentScoreUpload.new(student_score_upload_params)

    respond_to do |format|
      if @student_score_upload.save
        format.html { redirect_to @student_score_upload, notice: 'Student score upload was successfully created.' }
        format.json { render :show, status: :created, location: @student_score_upload }
      else
        format.html { render :new }
        format.json { render json: @student_score_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_score_uploads/1
  # PATCH/PUT /student_score_uploads/1.json
  def update
    respond_to do |format|
      if @student_score_upload.update(student_score_upload_params)
        format.html { redirect_to @student_score_upload, notice: 'Student score upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @student_score_upload }
      else
        format.html { render :edit }
        format.json { render json: @student_score_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_score_uploads/1
  # DELETE /student_score_uploads/1.json
  def destroy
    @student_score_upload.destroy
    respond_to do |format|
      format.html { redirect_to student_score_uploads_url, notice: 'Student score upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_score_upload
      @student_score_upload = StudentScoreUpload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_score_upload_params
      params.fetch(:student_score_upload, {})
    end
end
