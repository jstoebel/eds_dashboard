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

        if params[:adm_file].blank?
            flash[:notice] = "Please provide a file"
            redirect_to banner_term_adm_tep_index_path(adm.banner_term.id)
            return
        end

        authorize! :manage, adm
        student_file = StudentFile.create({
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

    def destroy
        adm_file = AdmFile.find params[:id]
        authorize! :read, adm_file
        adm_file.destroy
        flash[:notice] = "Removed file: #{adm_file.student_file.doc_file_name}"
        redirect_to banner_term_adm_tep_index_path(adm_file.adm_tep.banner_term.id)
    end

end
