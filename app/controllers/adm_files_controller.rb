class AdmFilesController < ApplicationController

    layout 'application'
    authorize_resource

    def download
        adm_file = AdmFile.find params[:adm_file_id]
        authorize! :read, adm_file
        send_file adm_file.student_file.doc.path
    end

    def create
        adm = AdmTep.find params[:adm_tep_id]

        student_file = StudentFile.create!({
            :doc => params[:adm_file][:doc],
            :student_id => adm.student.id
        })

        adm.adm_file = student_file

        if adm.save
            flash[:notice] = "File successfully uploaded"
        else
            flash[:notice] = "There was a problem uploading your file"
        end
        redirect_to banner_term_adm_tep_index_path(adm.banner_term.id)
    end

end
