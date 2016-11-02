# == Route Map
#
#                           Prefix Verb     URI Pattern                                                           Controller#Action
#          prog_exits_get_programs POST|GET /prog_exits/get_programs(.:format)                                    prog_exits#get_programs
#                     access_index GET      /access(.:format)                                                     access#index
#       access_change_psudo_status POST     /access/change_psudo_status(.:format)                                 access#change_psudo_status
#                    access_denied GET      /access_denied(.:format)                                              access#access_denied
#                           logout GET      /logout(.:format)                                                     access#logout
#                   praxis_results POST     /praxis_results(.:format)                                             praxis_results#create
#                new_praxis_result GET      /praxis_results/new(.:format)                                         praxis_results#new
#  clinical_site_clinical_teachers GET      /clinical_sites/:clinical_site_id/clinical_teachers(.:format)         clinical_teachers#index
#                   clinical_sites GET      /clinical_sites(.:format)                                             clinical_sites#index
#                                  POST     /clinical_sites(.:format)                                             clinical_sites#create
#                new_clinical_site GET      /clinical_sites/new(.:format)                                         clinical_sites#new
#               edit_clinical_site GET      /clinical_sites/:id/edit(.:format)                                    clinical_sites#edit
#                    clinical_site PATCH    /clinical_sites/:id(.:format)                                         clinical_sites#update
#                                  PUT      /clinical_sites/:id(.:format)                                         clinical_sites#update
#                clinical_teachers GET      /clinical_teachers(.:format)                                          clinical_teachers#index
#                                  POST     /clinical_teachers(.:format)                                          clinical_teachers#create
#             new_clinical_teacher GET      /clinical_teachers/new(.:format)                                      clinical_teachers#new
#            edit_clinical_teacher GET      /clinical_teachers/:id/edit(.:format)                                 clinical_teachers#edit
#                 clinical_teacher PATCH    /clinical_teachers/:id(.:format)                                      clinical_teachers#update
#                                  PUT      /clinical_teachers/:id(.:format)                                      clinical_teachers#update
#                   adm_tep_choose POST     /adm_tep/:adm_tep_id/choose(.:format)                                 adm_tep#choose
#                    adm_tep_admit GET      /adm_tep/:adm_tep_id/admit(.:format)                                  adm_tep#admit
#                 adm_tep_download GET      /adm_tep/:adm_tep_id/download(.:format)                               adm_tep#download
#                    adm_tep_index GET      /adm_tep(.:format)                                                    adm_tep#index
#                                  POST     /adm_tep(.:format)                                                    adm_tep#create
#                      new_adm_tep GET      /adm_tep/new(.:format)                                                adm_tep#new
#                     edit_adm_tep GET      /adm_tep/:id/edit(.:format)                                           adm_tep#edit
#                          adm_tep GET      /adm_tep/:id(.:format)                                                adm_tep#show
#                                  PATCH    /adm_tep/:id(.:format)                                                adm_tep#update
#                                  PUT      /adm_tep/:id(.:format)                                                adm_tep#update
#                    adm_st_choose POST     /adm_st/:adm_st_id/choose(.:format)                                   adm_st#choose
#                     adm_st_admit GET      /adm_st/:adm_st_id/admit(.:format)                                    adm_st#admit
#                  adm_st_download GET      /adm_st/:adm_st_id/download(.:format)                                 adm_st#download
#         adm_st_edit_st_paperwork GET      /adm_st/:adm_st_id/edit_st_paperwork(.:format)                        adm_st#edit_st_paperwork
#       adm_st_update_st_paperwork POST     /adm_st/:adm_st_id/update_st_paperwork(.:format)                      adm_st#update_st_paperwork
#                     adm_st_index GET      /adm_st(.:format)                                                     adm_st#index
#                                  POST     /adm_st(.:format)                                                     adm_st#create
#                       new_adm_st GET      /adm_st/new(.:format)                                                 adm_st#new
#                      edit_adm_st GET      /adm_st/:id/edit(.:format)                                            adm_st#edit
#                           adm_st GET      /adm_st/:id(.:format)                                                 adm_st#show
#                                  PATCH    /adm_st/:id(.:format)                                                 adm_st#update
#                                  PUT      /adm_st/:id(.:format)                                                 adm_st#update
#                 prog_exit_choose POST     /prog_exits/:prog_exit_id/choose(.:format)                            prog_exits#choose
#              prog_exit_need_exit GET      /prog_exits/:prog_exit_id/need_exit(.:format)                         prog_exits#need_exit
#                       prog_exits GET      /prog_exits(.:format)                                                 prog_exits#index
#                                  POST     /prog_exits(.:format)                                                 prog_exits#create
#                    new_prog_exit GET      /prog_exits/new(.:format)                                             prog_exits#new
#                   edit_prog_exit GET      /prog_exits/:id/edit(.:format)                                        prog_exits#edit
#                        prog_exit GET      /prog_exits/:id(.:format)                                             prog_exits#show
#                                  PATCH    /prog_exits/:id(.:format)                                             prog_exits#update
#                                  PUT      /prog_exits/:id(.:format)                                             prog_exits#update
#   program_prog_exit_new_specific GET      /programs/:program_id/prog_exits/:prog_exit_id/new_specific(.:format) prog_exits#new_specific
#               program_prog_exits GET      /programs/:program_id/prog_exits(.:format)                            prog_exits#index
#                                  POST     /programs/:program_id/prog_exits(.:format)                            prog_exits#create
#            new_program_prog_exit GET      /programs/:program_id/prog_exits/new(.:format)                        prog_exits#new
#           edit_program_prog_exit GET      /programs/:program_id/prog_exits/:id/edit(.:format)                   prog_exits#edit
#                program_prog_exit GET      /programs/:program_id/prog_exits/:id(.:format)                        prog_exits#show
#                                  PATCH    /programs/:program_id/prog_exits/:id(.:format)                        prog_exits#update
#                                  PUT      /programs/:program_id/prog_exits/:id(.:format)                        prog_exits#update
#                                  DELETE   /programs/:program_id/prog_exits/:id(.:format)                        prog_exits#destroy
#                         programs GET      /programs(.:format)                                                   programs#index
#                                  POST     /programs(.:format)                                                   programs#create
#                      new_program GET      /programs/new(.:format)                                               programs#new
#                     edit_program GET      /programs/:id/edit(.:format)                                          programs#edit
#                          program GET      /programs/:id(.:format)                                               programs#show
#                                  PATCH    /programs/:id(.:format)                                               programs#update
#                                  PUT      /programs/:id(.:format)                                               programs#update
#                                  DELETE   /programs/:id(.:format)                                               programs#destroy
#       clinical_assignment_choose POST     /clinical_assignments/:clinical_assignment_id/choose(.:format)        clinical_assignments#choose
#             clinical_assignments GET      /clinical_assignments(.:format)                                       clinical_assignments#index
#                                  POST     /clinical_assignments(.:format)                                       clinical_assignments#create
#          new_clinical_assignment GET      /clinical_assignments/new(.:format)                                   clinical_assignments#new
#         edit_clinical_assignment GET      /clinical_assignments/:id/edit(.:format)                              clinical_assignments#edit
#              clinical_assignment PATCH    /clinical_assignments/:id(.:format)                                   clinical_assignments#update
#                                  PUT      /clinical_assignments/:id(.:format)                                   clinical_assignments#update
#             praxis_result_delete GET      /praxis_results/:praxis_result_id/delete(.:format)                    praxis_results#delete
#           student_praxis_results GET      /students/:student_id/praxis_results(.:format)                        praxis_results#index
#               edit_praxis_result GET      /praxis_results/:id/edit(.:format)                                    praxis_results#edit
#                    praxis_result GET      /praxis_results/:id(.:format)                                         praxis_results#show
#                                  PATCH    /praxis_results/:id(.:format)                                         praxis_results#update
#                                  PUT      /praxis_results/:id(.:format)                                         praxis_results#update
#                                  DELETE   /praxis_results/:id(.:format)                                         praxis_results#destroy
#                   student_issues GET      /students/:student_id/issues(.:format)                                issues#index
#                                  POST     /students/:student_id/issues(.:format)                                issues#create
#                new_student_issue GET      /students/:student_id/issues/new(.:format)                            issues#new
#            student_student_files GET      /students/:student_id/student_files(.:format)                         student_files#index
#                                  POST     /students/:student_id/student_files(.:format)                         student_files#create
#         new_student_student_file GET      /students/:student_id/student_files/new(.:format)                     student_files#new
#                     student_file DELETE   /student_files/:id(.:format)                                          student_files#destroy
#                         students GET      /students(.:format)                                                   students#index
#                          student GET      /students/:id(.:format)                                               students#show
#            student_file_download GET      /student_files/:student_file_id/download(.:format)                    student_files#download
#                    student_files GET      /student_files(.:format)                                              student_files#index
#                                  POST     /student_files(.:format)                                              student_files#create
#                 new_student_file GET      /student_files/new(.:format)                                          student_files#new
#                edit_student_file GET      /student_files/:id/edit(.:format)                                     student_files#edit
#                                  GET      /student_files/:id(.:format)                                          student_files#show
#                                  PATCH    /student_files/:id(.:format)                                          student_files#update
#                                  PUT      /student_files/:id(.:format)                                          student_files#update
#                                  DELETE   /student_files/:id(.:format)                                          student_files#destroy
#              issue_issue_updates GET      /issues/:issue_id/issue_updates(.:format)                             issue_updates#index
#                                  POST     /issues/:issue_id/issue_updates(.:format)                             issue_updates#create
#           new_issue_issue_update GET      /issues/:issue_id/issue_updates/new(.:format)                         issue_updates#new
#                edit_issue_update GET      /issue_updates/:id/edit(.:format)                                     issue_updates#edit
#                     issue_update GET      /issue_updates/:id(.:format)                                          issue_updates#show
#                                  PATCH    /issue_updates/:id(.:format)                                          issue_updates#update
#                                  PUT      /issue_updates/:id(.:format)                                          issue_updates#update
#                                  DELETE   /issue_updates/:id(.:format)                                          issue_updates#destroy
#                           issues GET      /issues(.:format)                                                     issues#index
#                                  POST     /issues(.:format)                                                     issues#create
#                        new_issue GET      /issues/new(.:format)                                                 issues#new
#                       edit_issue GET      /issues/:id/edit(.:format)                                            issues#edit
#                            issue GET      /issues/:id(.:format)                                                 issues#show
#                                  PATCH    /issues/:id(.:format)                                                 issues#update
#                                  PUT      /issues/:id(.:format)                                                 issues#update
#                                  DELETE   /issues/:id(.:format)                                                 issues#destroy
#        banner_term_adm_tep_index GET      /banner_terms/:banner_term_id/adm_tep(.:format)                       adm_tep#index
#         banner_term_adm_st_index GET      /banner_terms/:banner_term_id/adm_st(.:format)                        adm_st#index
#           banner_term_prog_exits GET      /banner_terms/:banner_term_id/prog_exits(.:format)                    prog_exits#index
# banner_term_clinical_assignments GET      /banner_terms/:banner_term_id/clinical_assignments(.:format)          clinical_assignments#index
#                     banner_terms GET      /banner_terms(.:format)                                               banner_terms#index
#                                  POST     /banner_terms(.:format)                                               banner_terms#create
#                  new_banner_term GET      /banner_terms/new(.:format)                                           banner_terms#new
#                 edit_banner_term GET      /banner_terms/:id/edit(.:format)                                      banner_terms#edit
#                      banner_term GET      /banner_terms/:id(.:format)                                           banner_terms#show
#                                  PATCH    /banner_terms/:id(.:format)                                           banner_terms#update
#                                  PUT      /banner_terms/:id(.:format)                                           banner_terms#update
#                                  DELETE   /banner_terms/:id(.:format)                                           banner_terms#destroy
#                             root GET      /                                                                     access#index
#

require 'api_constraints'
Rails.application.routes.draw do

  #A resource must be top level before it can be nested in another resource (I think)
  resources :praxis_results, only: [:new, :create]
  resources :students, only: [:index, :show], shallow: true do
    patch "update_presumed_status"
    resources :praxis_results, only: [:index, :show, :edit, :update, :destroy] do
      get "delete"
    end
    resources :issues, only: [:index, :new, :create, :destroy, :edit, :update]
    resources :student_files, only: [:new, :create, :index, :delete, :destroy]
    resources :concern_dashboard, only: [:index], :path => "concerns"
  end

  match 'prog_exits/get_programs', via: [:post, :get]

  resources :access, only: [:index]
  # match  "/access/get_env" => "access#get_env", :via => :get
  match "/access/change_psudo_status" => "access#change_psudo_status", :via => :post
  match "/access_denied" => "access#access_denied", :via => :get
  match "/logout" => "access#logout", :via => :post


  resources :clinical_sites, only: [:index, :edit, :update, :new, :create, :destroy], shallow: true do
    resources :clinical_teachers, only: [:index]
    get "delete"
  end

  resources :clinical_teachers, only: [:index, :new, :create, :edit, :update, :destroy] do
    get "delete"
  end

  resources :reports, only: [:index] do #reports is here
  end

  resources :assessment_items, only: [ :show, :create, :destroy] do
  end

  match 'assessment_items/update', :via => :patch

  resources :item_levels, only: [:show, :create, :update, :destroy] do
  end

  resources :assessment_versions, only: [:index, :create, :show, :update, :destroy] do
    resources :assessment_items, only: [:index] do
      resources :item_levels, only: [:index]
    end
    get "delete"
    put "update"
  end

  resources :version_habtm_items, only: [:create, :destroy]

  resources :assessments, only: [:index, :new, :create, :edit, :update, :delete, :destroy], shallow: true do
    resources :assessment_versions, only: [:index] do
    end
    get "delete"
  end

# resources :clinical_teachers, only: [:index, :edit, :update, :new, :create]


  resources :adm_tep, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    post "choose"
    get "admit"
    get "download"
  end

  resources :adm_st, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    post "choose"   #choose a term to display in index
    get "admit"
    get "download"  #download admission letter
    get "edit_st_paperwork"
    post "update_st_paperwork"
  end

  resources :prog_exits, only: [:index, :show, :new, :create, :edit, :update] do
    post "choose"   #choose a term to display in index
    get "need_exit"

    # get 'get_programs', via: :get
  end

  resources :programs do
    resources :prog_exits do
      get "new_specific"
    end
  end

  resources :clinical_assignments, only: [:index, :new, :create, :edit, :update, :destroy] do
    post "choose"
  end

  resources :students, only: [:index, :show], shallow: true do
    resources :praxis_results, only: [:index, :show, :edit, :update, :destroy] do
      get "delete"
    end
    resources :issues, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :student_files, only: [:new, :create, :index, :delete, :destroy]
    resources :pgps, only: [:new, :create, :index, :destroy, :edit, :update, :show], shallow:true do
      resources :pgp_scores, only: [:index, :edit, :update, :show, :new, :create, :destroy]
    end
  end

  resources :fois, only: [:index, :create, :show, :import]

  resources :fois do
    collection { post :import }
  end

  resources :praxis_result_temps, only: [:index], shallow: true do
    post "resolve"
  end

  resources :student_files do
    get "download"
  end

  resources :issues, only: [:index, :new, :create, :destroy, :edit, :update],  shallow: true do
    resources :issue_updates do
        patch 'update'
    end
  end

  resources :pgps, shallow: true do
    resources :pgp_scores
  end

  resources :banner_terms, shallow: true do
    resources :adm_tep, only: [:index]
    resources :adm_st, only: [:index]
    resources :prog_exits, only: [:index]
    resources :clinical_assignments, only: [:index]
  end

  root 'access#index'

end
