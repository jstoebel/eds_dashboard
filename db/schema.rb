# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170417195309) do

  create_table "adm_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "adm_tep_id"
    t.integer  "student_file_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "adm_st", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",                          null: false
    t.integer  "BannerTerm_BannerTerm"
    t.integer  "Attempt"
    t.float    "OverallGPA",            limit: 24
    t.float    "CoreGPA",               limit: 24
    t.boolean  "STAdmitted"
    t.datetime "STAdmitDate"
    t.integer  "STTerm"
    t.text     "Notes",                 limit: 65535
    t.boolean  "background_check"
    t.boolean  "beh_train"
    t.boolean  "conf_train"
    t.boolean  "kfets_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_file_id"
    t.index ["BannerTerm_BannerTerm"], name: "fk_AdmST_BannerTerm1_idx", using: :btree
    t.index ["student_file_id"], name: "fk_rails_e532a76011", using: :btree
    t.index ["student_id"], name: "fk_rails_81f4e9ee93", using: :btree
  end

  create_table "adm_tep", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",                          null: false
    t.integer  "Program_ProgCode",                    null: false
    t.integer  "BannerTerm_BannerTerm",               null: false
    t.integer  "Attempt"
    t.float    "GPA",                   limit: 24
    t.float    "GPA_last30",            limit: 24
    t.integer  "EarnedCredits"
    t.boolean  "PortfolioPass"
    t.boolean  "TEPAdmit"
    t.datetime "TEPAdmitDate"
    t.text     "Notes",                 limit: 65535
    t.integer  "student_file_id"
    t.index ["BannerTerm_BannerTerm"], name: "fk_AdmTEP_BannerTerm1_idx", using: :btree
    t.index ["Program_ProgCode"], name: "fk_AdmTEP_Program1_idx", using: :btree
    t.index ["student_file_id"], name: "fk_rails_065e9525b2", using: :btree
    t.index ["student_id"], name: "fk_rails_967a6101da", using: :btree
  end

  create_table "advisor_assignments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "student_id",     null: false
    t.integer "tep_advisor_id", null: false
    t.index ["student_id", "tep_advisor_id"], name: "index_advisor_assignments_on_student_id_and_tep_advisor_id", unique: true, using: :btree
    t.index ["tep_advisor_id"], name: "fk_rails_a939fa1e55", using: :btree
  end

  create_table "alumni_info", primary_key: "AlumniID", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "Student_Bnum", limit: 9,  null: false
    t.datetime "Date"
    t.string   "FirstName",    limit: 45
    t.string   "LastName",     limit: 45
    t.string   "Email",        limit: 45
    t.string   "Phone",        limit: 45
    t.string   "Address1",     limit: 45
    t.string   "Address2",     limit: 45
    t.string   "City",         limit: 45
    t.string   "State",        limit: 45
    t.string   "ZIP",          limit: 45
    t.index ["Student_Bnum"], name: "fk_AlumniInfo_Student1_idx", using: :btree
  end

  create_table "assessment_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "assessment_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "start_term"
    t.integer  "end_term"
    t.text     "description",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assessment_id"], name: "index_assessment_items_on_assessment_id", using: :btree
    t.index ["end_term"], name: "fk_rails_70fb68bab9", using: :btree
    t.index ["start_term"], name: "fk_rails_7a5cf3e547", using: :btree
  end

  create_table "assessments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banner_terms", primary_key: "BannerTerm", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "PlainTerm",     limit: 45, null: false
    t.datetime "StartDate",                null: false
    t.datetime "EndDate",                  null: false
    t.integer  "AYStart",                  null: false
    t.boolean  "standard_term"
  end

  create_table "banner_updates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_term"
    t.integer  "end_term"
    t.index ["end_term"], name: "fk_rails_2219dc81d4", using: :btree
    t.index ["start_term"], name: "fk_rails_be69fdca92", using: :btree
  end

  create_table "clinical_assignments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "student_id",                     null: false
    t.integer "clinical_teacher_id",            null: false
    t.integer "Term",                           null: false
    t.string  "Level",               limit: 45
    t.date    "StartDate"
    t.date    "EndDate"
    t.integer "transcript_id"
    t.index ["clinical_teacher_id"], name: "fk_ClinicalAssignments_ClinicalTeacher1_idx", using: :btree
    t.index ["student_id"], name: "fk_rails_4eae3b4e55", using: :btree
    t.index ["transcript_id"], name: "fk_rails_0f54585493", using: :btree
  end

  create_table "clinical_sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "SiteName",     limit: 45, null: false
    t.string "City",         limit: 45
    t.string "County",       limit: 45
    t.string "Principal",    limit: 45
    t.string "District",     limit: 45
    t.string "phone"
    t.string "receptionist"
    t.string "website"
    t.string "email"
  end

  create_table "clinical_teachers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "Bnum",                limit: 45
    t.string   "FirstName",           limit: 45, null: false
    t.string   "LastName",            limit: 45, null: false
    t.string   "Email",               limit: 45
    t.string   "Subject",             limit: 45
    t.integer  "clinical_site_id",               null: false
    t.integer  "Rank"
    t.integer  "YearsExp"
    t.datetime "begin_service"
    t.datetime "epsb_training"
    t.datetime "ct_record"
    t.datetime "co_teacher_training"
    t.index ["clinical_site_id"], name: "fk_ClinicalTeacher_ClinicalSite1_idx", using: :btree
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "dispositions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "code"
    t.text     "description", limit: 65535
    t.boolean  "current"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "downtimes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "reason",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "active"
  end

  create_table "employment", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id"
    t.integer  "category"
    t.string   "employer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["student_id"], name: "fk_rails_8b14daa8ce", using: :btree
  end

  create_table "exit_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "ExitCode",    limit: 5,  null: false
    t.string "ExitDiscrip", limit: 45, null: false
  end

  create_table "forms_of_intention", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",      null: false
    t.datetime "date_completing"
    t.boolean  "new_form"
    t.integer  "major_id"
    t.boolean  "seek_cert"
    t.boolean  "eds_only"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["major_id"], name: "fk_rails_34628389e5", using: :btree
    t.index ["student_id"], name: "fk_rails_21802f4afc", using: :btree
  end

  create_table "issue_updates", primary_key: "UpdateID", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text     "UpdateName",               limit: 65535,                null: false
    t.text     "Description",              limit: 65535,                null: false
    t.integer  "Issues_IssueID",                                        null: false
    t.integer  "tep_advisors_AdvisorBnum",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                                default: true, null: false
    t.boolean  "addressed"
    t.string   "status"
    t.index ["Issues_IssueID"], name: "fk_IssueUpdates_Issues1_idx", using: :btree
    t.index ["tep_advisors_AdvisorBnum"], name: "fk_IssueUpdates_tep_advisors1_idx", using: :btree
  end

  create_table "issues", primary_key: "IssueID", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",                                            null: false
    t.text     "Name",                     limit: 65535,                null: false
    t.text     "Description",              limit: 65535,                null: false
    t.integer  "tep_advisors_AdvisorBnum",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                                default: true, null: false
    t.boolean  "positive"
    t.integer  "disposition_id"
    t.index ["disposition_id"], name: "fk_rails_7e9ae84f98", using: :btree
    t.index ["student_id"], name: "fk_rails_ea791380de", using: :btree
    t.index ["tep_advisors_AdvisorBnum"], name: "fk_Issues_tep_advisors1_idx", using: :btree
  end

  create_table "item_levels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "assessment_item_id"
    t.text     "descriptor",         limit: 65535
    t.string   "level"
    t.integer  "ord"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "passing"
    t.index ["assessment_item_id"], name: "index_item_levels_on_assessment_item_id", using: :btree
  end

  create_table "last_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["student_id"], name: "fk_rails_3940dc28b0", using: :btree
  end

  create_table "majors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
  end

  create_table "pgp_scores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "pgp_id"
    t.integer  "goal_score"
    t.text     "score_reason", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["pgp_id"], name: "fk_rails_e14b2a6a06", using: :btree
  end

  create_table "pgps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id"
    t.string   "goal_name"
    t.text     "description", limit: 65535
    t.text     "plan",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "strategies",  limit: 65535
    t.index ["student_id"], name: "fk_rails_4f8f978860", using: :btree
  end

  create_table "praxis_prep", primary_key: "TestID", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "student_id",                             null: false
    t.integer "PraxisTest_TestCode",                    null: false
    t.string  "Sub1Name",            limit: 45
    t.float   "Sub1Score",           limit: 24
    t.string  "Sub2Name",            limit: 45
    t.float   "Sub2Score",           limit: 24
    t.string  "Sub3Name",            limit: 45
    t.float   "Sub3Score",           limit: 24
    t.string  "Sub4Name",            limit: 45
    t.float   "Sub4Score",           limit: 24
    t.string  "Sub5Name",            limit: 45
    t.float   "Sub5Score",           limit: 24
    t.string  "Sub6Name",            limit: 45
    t.float   "Sub6Score",           limit: 24
    t.string  "Sub7Name",            limit: 45
    t.float   "Sub7Score",           limit: 24
    t.float   "TestScore",           limit: 24
    t.boolean "RemediationRequired"
    t.boolean "RemediationComplete"
    t.text    "Notes",               limit: 4294967295
    t.index ["PraxisTest_TestCode"], name: "fk_PraxisPrep_PraxisTest1_idx", using: :btree
    t.index ["student_id"], name: "fk_rails_4112037443", using: :btree
  end

  create_table "praxis_result_temps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "student_id"
    t.integer  "praxis_test_id"
    t.datetime "test_date"
    t.integer  "test_score"
    t.integer  "best_score"
  end

  create_table "praxis_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",     null: false
    t.integer  "praxis_test_id"
    t.datetime "test_date"
    t.datetime "reg_date"
    t.string   "paid_by"
    t.integer  "test_score"
    t.integer  "best_score"
    t.index ["praxis_test_id"], name: "fk_praxis_results_praxis_tests_idx", using: :btree
    t.index ["student_id", "praxis_test_id", "test_date"], name: "index_by_stu_test_date", unique: true, using: :btree
    t.index ["student_id"], name: "fk_praxis_results_students_idx", using: :btree
  end

  create_table "praxis_sub_temps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "praxis_result_temp_id", null: false
    t.integer "sub_number"
    t.string  "name"
    t.integer "pts_earned"
    t.integer "pts_aval"
    t.integer "avg_high"
    t.integer "avg_low"
    t.index ["praxis_result_temp_id"], name: "fk_rails_c72a4ab38d", using: :btree
  end

  create_table "praxis_subtest_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "praxis_result_id", null: false
    t.integer "sub_number"
    t.string  "name"
    t.integer "pts_earned"
    t.integer "pts_aval"
    t.integer "avg_high"
    t.integer "avg_low"
    t.index ["praxis_result_id"], name: "fk_rails_2b271e70f8", using: :btree
  end

  create_table "praxis_tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "TestCode",         limit: 45, null: false
    t.string  "TestName"
    t.integer "CutScore"
    t.string  "TestFamily",       limit: 1
    t.string  "Sub1"
    t.string  "Sub2"
    t.string  "Sub3"
    t.string  "Sub4"
    t.string  "Sub5"
    t.string  "Sub6"
    t.string  "Sub7"
    t.integer "Program_ProgCode"
    t.boolean "CurrentTest"
    t.index ["Program_ProgCode"], name: "fk_PraxisTest_Program1_idx", using: :btree
    t.index ["TestCode"], name: "TestCode_UNIQUE", unique: true, using: :btree
  end

  create_table "praxis_updates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "report_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prog_exits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",                      null: false
    t.integer  "Program_ProgCode",                null: false
    t.integer  "ExitCode_ExitCode",               null: false
    t.integer  "ExitTerm",                        null: false
    t.datetime "ExitDate"
    t.float    "GPA",               limit: 24
    t.float    "GPA_last60",        limit: 24
    t.datetime "RecommendDate"
    t.text     "Details",           limit: 65535
    t.index ["ExitCode_ExitCode"], name: "fk_Exit_ExitCode1_idx", using: :btree
    t.index ["ExitTerm"], name: "prog_exits_ExitTerm_fk", using: :btree
    t.index ["Program_ProgCode"], name: "fk_Exit__Program_idx", using: :btree
    t.index ["student_id", "Program_ProgCode"], name: "index_prog_exits_on_student_id_and_Program_ProgCode", using: :btree
  end

  create_table "programs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "ProgCode",     limit: 10,  null: false
    t.string  "EPSBProgName", limit: 100
    t.string  "EDSProgName",  limit: 45
    t.boolean "Current"
    t.string  "license_code"
    t.index ["ProgCode"], name: "ProgCode_UNIQUE", unique: true, using: :btree
  end

  create_table "roles", primary_key: "idRoles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "RoleName", limit: 45, null: false
    t.index ["RoleName"], name: "RoleName_UNIQUE", unique: true, using: :btree
  end

  create_table "st_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "adm_st_id"
    t.integer  "student_file_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "student_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id",                                  null: false
    t.boolean  "active",                       default: true
    t.string   "doc_file_name",    limit: 100
    t.string   "doc_content_type", limit: 100
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.index ["student_id"], name: "fk_rails_78ba6603b4", using: :btree
  end

  create_table "student_score_temps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id"
    t.integer  "item_level_id"
    t.datetime "scored_at"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_score_upload_id"
    t.index ["student_score_upload_id"], name: "fk_rails_96a8917b0f", using: :btree
  end

  create_table "student_score_uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "source"
    t.boolean  "success"
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "student_scores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "student_id"
    t.integer  "item_level_id"
    t.datetime "scored_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_score_upload_id"
    t.index ["item_level_id"], name: "index_student_scores_on_item_level_id", using: :btree
    t.index ["student_id"], name: "index_student_scores_on_student_id", using: :btree
    t.index ["student_score_upload_id"], name: "fk_rails_12c700da29", using: :btree
  end

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "Bnum",                    limit: 9,     null: false
    t.string  "FirstName",               limit: 45,    null: false
    t.string  "PreferredFirst",          limit: 45
    t.string  "MiddleName",              limit: 45
    t.string  "LastName",                limit: 45,    null: false
    t.string  "PrevLast",                limit: 45
    t.string  "EnrollmentStatus",        limit: 45
    t.string  "Classification",          limit: 45
    t.string  "CurrentMajor1",           limit: 45
    t.string  "concentration1"
    t.string  "CurrentMajor2",           limit: 45
    t.string  "concentration2"
    t.string  "CellPhone",               limit: 45
    t.string  "CurrentMinors"
    t.string  "Email",                   limit: 100
    t.string  "CPO",                     limit: 45
    t.text    "withdraws",               limit: 65535
    t.integer "term_graduated"
    t.string  "gender"
    t.string  "race"
    t.boolean "hispanic"
    t.integer "term_expl_major"
    t.integer "term_major"
    t.string  "presumed_status"
    t.text    "presumed_status_comment", limit: 65535
    t.index ["Bnum"], name: "Bnum_UNIQUE", unique: true, using: :btree
    t.index ["term_expl_major"], name: "fk_rails_f9760072bf", using: :btree
    t.index ["term_graduated"], name: "fk_rails_0cb4e31ef0", using: :btree
    t.index ["term_major"], name: "fk_rails_02beb2ceb0", using: :btree
  end

  create_table "temp_foi", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "student_id"
    t.string   "date_completing"
    t.boolean  "new_form"
    t.integer  "major_id"
    t.boolean  "seek_cert"
    t.boolean  "eds_only"
    t.string   "foi_errors"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["major_id"], name: "fk_rails_1885a219a7", using: :btree
    t.index ["student_id"], name: "fk_rails_89ceaae199", using: :btree
  end

  create_table "tep_advisors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "AdvisorBnum", limit: 9,  null: false
    t.string  "Salutation",  limit: 45, null: false
    t.integer "user_id"
    t.string  "first_name",             null: false
    t.string  "last_name",              null: false
    t.string  "email"
    t.index ["AdvisorBnum"], name: "AdvisorBnum_UNIQUE", unique: true, using: :btree
    t.index ["user_id"], name: "fk_rails_50ba8b67f4", using: :btree
  end

  create_table "transcript", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "student_id",                      null: false
    t.string  "crn",               limit: 45,    null: false
    t.string  "course_code",       limit: 45,    null: false
    t.string  "course_section"
    t.string  "course_name",       limit: 100
    t.integer "term_taken",                      null: false
    t.float   "grade_pt",          limit: 24
    t.string  "grade_ltr",         limit: 2
    t.float   "quality_points",    limit: 24
    t.float   "credits_attempted", limit: 24
    t.float   "credits_earned",    limit: 24
    t.string  "reg_status",        limit: 45
    t.text    "instructors",       limit: 65535
    t.boolean "gpa_include",                     null: false
    t.index ["student_id", "crn", "term_taken"], name: "index_transcript_on_student_id_and_crn_and_term_taken", unique: true, using: :btree
    t.index ["term_taken"], name: "fk_transcript_banner_terms1_idx", using: :btree
  end

  create_table "trigrams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id"
    t.string  "owner_type"
    t.string  "fuzzy_field"
    t.index ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_by_owner", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "UserName",      limit: 45,  null: false
    t.string  "FirstName",     limit: 45,  null: false
    t.string  "LastName",      limit: 45,  null: false
    t.string  "Email",         limit: 100, null: false
    t.integer "Roles_idRoles",             null: false
    t.index ["Roles_idRoles"], name: "fk_users_Roles1_idx", using: :btree
    t.index ["UserName"], name: "UserName_UNIQUE", unique: true, using: :btree
  end

  add_foreign_key "adm_st", "banner_terms", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm", name: "fk_AdmST_BannerTerm"
  add_foreign_key "adm_st", "student_files"
  add_foreign_key "adm_st", "students"
  add_foreign_key "adm_tep", "banner_terms", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm", name: "fk_AdmTEP_BannerTerm"
  add_foreign_key "adm_tep", "programs", column: "Program_ProgCode"
  add_foreign_key "adm_tep", "student_files"
  add_foreign_key "adm_tep", "students"
  add_foreign_key "advisor_assignments", "students"
  add_foreign_key "advisor_assignments", "tep_advisors"
  add_foreign_key "alumni_info", "students", column: "Student_Bnum", primary_key: "Bnum", name: "fk_AlumniInfo_Student"
  add_foreign_key "assessment_items", "banner_terms", column: "end_term", primary_key: "BannerTerm"
  add_foreign_key "assessment_items", "banner_terms", column: "start_term", primary_key: "BannerTerm"
  add_foreign_key "banner_updates", "banner_terms", column: "end_term", primary_key: "BannerTerm"
  add_foreign_key "banner_updates", "banner_terms", column: "start_term", primary_key: "BannerTerm"
  add_foreign_key "clinical_assignments", "clinical_teachers", name: "clinical_assignments_clinical_teacher_id_fk"
  add_foreign_key "clinical_assignments", "students"
  add_foreign_key "clinical_assignments", "transcript"
  add_foreign_key "clinical_teachers", "clinical_sites", name: "clinical_teachers_clinical_site_id_fk"
  add_foreign_key "employment", "students"
  add_foreign_key "forms_of_intention", "majors"
  add_foreign_key "forms_of_intention", "students"
  add_foreign_key "issue_updates", "issues", column: "Issues_IssueID", primary_key: "IssueID", name: "fk_IssueUpdates_Issues"
  add_foreign_key "issue_updates", "tep_advisors", column: "tep_advisors_AdvisorBnum"
  add_foreign_key "issues", "dispositions"
  add_foreign_key "issues", "students"
  add_foreign_key "issues", "tep_advisors", column: "tep_advisors_AdvisorBnum"
  add_foreign_key "last_names", "students"
  add_foreign_key "pgp_scores", "pgps"
  add_foreign_key "pgps", "students"
  add_foreign_key "praxis_prep", "praxis_tests", column: "PraxisTest_TestCode"
  add_foreign_key "praxis_prep", "students"
  add_foreign_key "praxis_results", "praxis_tests"
  add_foreign_key "praxis_results", "students"
  add_foreign_key "praxis_sub_temps", "praxis_result_temps"
  add_foreign_key "praxis_subtest_results", "praxis_results"
  add_foreign_key "praxis_tests", "programs", column: "Program_ProgCode"
  add_foreign_key "prog_exits", "banner_terms", column: "ExitTerm", primary_key: "BannerTerm", name: "prog_exits_ExitTerm_fk"
  add_foreign_key "prog_exits", "exit_codes", column: "ExitCode_ExitCode"
  add_foreign_key "prog_exits", "programs", column: "Program_ProgCode"
  add_foreign_key "prog_exits", "students"
  add_foreign_key "student_files", "students"
  add_foreign_key "student_score_temps", "student_score_uploads"
  add_foreign_key "student_scores", "student_score_uploads"
  add_foreign_key "students", "banner_terms", column: "term_expl_major", primary_key: "BannerTerm"
  add_foreign_key "students", "banner_terms", column: "term_graduated", primary_key: "BannerTerm"
  add_foreign_key "students", "banner_terms", column: "term_major", primary_key: "BannerTerm"
  add_foreign_key "temp_foi", "majors"
  add_foreign_key "temp_foi", "students", primary_key: "Bnum"
  add_foreign_key "tep_advisors", "users"
  add_foreign_key "transcript", "banner_terms", column: "term_taken", primary_key: "BannerTerm", name: "fk_transcript_banner_terms"
  add_foreign_key "transcript", "students"
  add_foreign_key "users", "roles", column: "Roles_idRoles", primary_key: "idRoles", name: "fk_users_Roles"
end
