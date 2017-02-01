class AdmFilesController < ApplicationController

    layout 'application'
    authorize_resource

    def download
        adm_file = AdmFile.find params[:adm_file_id]
        authorize! :read, adm_file
        send_file adm_file.student_file.doc.path
    end

end
