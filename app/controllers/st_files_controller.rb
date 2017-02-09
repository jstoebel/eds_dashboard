class StFilesController < ApplicationController

    layout 'application'
    authorize_resource

    def download
        adm_file = StFile.find params[:st_file_id]
        authorize! :read, st_file
        send_file st_file.student_file.doc.path
    end

    def create
        adm = AdmSt.find params[:adm_st_id]

        if params[:st_file].blank?
            flash[:notice] = "Please provide a file"
            redirect_to banner_term_adm_st_index_path(adm.banner_term.id)
            return
        end

        authorize! :manage, adm
        student_file = StudentFile.create({
            :doc => params[:st_file][:doc],
            :student_id => adm.student.id
        })

        adm.st_file = student_file

        if adm.save
            flash[:notice] = "File successfully uploaded"
        else
            flash[:notice] = "There was a problem uploading your file"
        end
        redirect_to banner_term_adm_st_index_path(adm.banner_term.id)
    end

    def destroy
        st_file = StFile.find params[:id]
        authorize! :read, st_file
        st_file.destroy
        flash[:notice] = "Removed file: #{st_file.student_file.doc_file_name}"
        redirect_to banner_term_adm_st_index_path(st_file.adm_st.banner_term.id)
    end


end
