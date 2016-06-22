# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160622134750) do

  create_table "adm_st", force: true do |t|
    t.integer  "student_id",                       null: false
    t.integer  "BannerTerm_BannerTerm"
    t.integer  "Attempt",                          null: false
    t.float    "OverallGPA",            limit: 24
    t.float    "CoreGPA",               limit: 24
    t.boolean  "STAdmitted"
    t.datetime "STAdmitDate"
    t.integer  "STTerm"
    t.text     "Notes"
    t.boolean  "background_check"
    t.boolean  "beh_train"
    t.boolean  "conf_train"
    t.boolean  "kfets_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_file_id"
  end

  add_index "adm_st", ["BannerTerm_BannerTerm"], name: "fk_AdmST_BannerTerm1_idx", using: :btree
  add_index "adm_st", ["student_file_id"], name: "adm_st_student_file_id_fk", using: :btree
  add_index "adm_st", ["student_id"], name: "adm_st_student_id_fk", using: :btree

  create_table "adm_tep", force: true do |t|
    t.integer  "student_id",                       null: false
    t.integer  "Program_ProgCode",                 null: false
    t.integer  "BannerTerm_BannerTerm",            null: false
    t.integer  "Attempt",                          null: false
    t.float    "GPA",                   limit: 24
    t.float    "GPA_last30",            limit: 24
    t.integer  "EarnedCredits"
    t.boolean  "PortfolioPass"
    t.boolean  "TEPAdmit"
    t.datetime "TEPAdmitDate"
    t.text     "Notes"
    t.integer  "student_file_id"
  end

  add_index "adm_tep", ["BannerTerm_BannerTerm"], name: "fk_AdmTEP_BannerTerm1_idx", using: :btree
  add_index "adm_tep", ["Program_ProgCode"], name: "fk_AdmTEP_Program1_idx", using: :btree
  add_index "adm_tep", ["student_file_id"], name: "adm_tep_student_file_id_fk", using: :btree
  add_index "adm_tep", ["student_id"], name: "adm_tep_student_id_fk", using: :btree

  create_table "advisor_assignments", force: true do |t|
    t.integer "student_id",     null: false
    t.integer "tep_advisor_id", null: false
  end

  add_index "advisor_assignments", ["student_id", "tep_advisor_id"], name: "index_advisor_assignments_on_student_id_and_tep_advisor_id", unique: true, using: :btree
  add_index "advisor_assignments", ["tep_advisor_id"], name: "advisor_assignments_tep_advisor_id_fk", using: :btree

  create_table "alumni_info", primary_key: "AlumniID", force: true do |t|
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
  end

  add_index "alumni_info", ["Student_Bnum"], name: "fk_AlumniInfo_Student1_idx", using: :btree

  create_table "assessment_items", force: true do |t|
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "assessment_versions", force: true do |t|
    t.integer  "assessment_id", null: false
    t.integer  "version_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_versions", ["assessment_id"], name: "assessment_versions_assessment_id_fk", using: :btree

  create_table "assessments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banner_terms", primary_key: "BannerTerm", force: true do |t|
    t.string   "PlainTerm", limit: 45, null: false
    t.datetime "StartDate",            null: false
    t.datetime "EndDate",              null: false
    t.integer  "AYStart",              null: false
  end

  create_table "banner_updates", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_term"
    t.integer  "end_term"
  end

  add_index "banner_updates", ["end_term"], name: "banner_updates_end_term_fk", using: :btree
  add_index "banner_updates", ["start_term"], name: "banner_updates_start_term_fk", using: :btree

  create_table "clinical_assignments", force: true do |t|
    t.integer "student_id",                     null: false
    t.integer "clinical_teacher_id",            null: false
    t.integer "Term",                           null: false
    t.string  "CourseID",            limit: 45, null: false
    t.string  "Level",               limit: 45
    t.date    "StartDate"
    t.date    "EndDate"
  end

  add_index "clinical_assignments", ["clinical_teacher_id"], name: "fk_ClinicalAssignments_ClinicalTeacher1_idx", using: :btree
  add_index "clinical_assignments", ["student_id"], name: "clinical_assignments_student_id_fk", using: :btree

  create_table "clinical_sites", force: true do |t|
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

  create_table "clinical_teachers", force: true do |t|
    t.string  "Bnum",             limit: 45
    t.string  "FirstName",        limit: 45, null: false
    t.string  "LastName",         limit: 45, null: false
    t.string  "Email",            limit: 45
    t.string  "Subject",          limit: 45
    t.integer "clinical_site_id",            null: false
    t.integer "Rank"
    t.integer "YearsExp"
  end

  add_index "clinical_teachers", ["clinical_site_id"], name: "fk_ClinicalTeacher_ClinicalSite1_idx", using: :btree

  create_table "employment", primary_key: "EmpID", force: true do |t|
    t.integer "student_id",             null: false
    t.date    "EmpDate",                null: false
    t.string  "EmpCategory", limit: 45
    t.string  "Employer",    limit: 45
  end

  add_index "employment", ["student_id"], name: "employment_student_id_fk", using: :btree

  create_table "exit_codes", force: true do |t|
    t.string "ExitCode",    limit: 5,  null: false
    t.string "ExitDiscrip", limit: 45, null: false
  end

  create_table "forms_of_intention", force: true do |t|
    t.integer  "student_id",      null: false
    t.datetime "date_completing"
    t.boolean  "new_form"
    t.integer  "major_id"
    t.boolean  "seek_cert"
    t.boolean  "eds_only"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forms_of_intention", ["major_id"], name: "forms_of_intention_major_id_fk", using: :btree
  add_index "forms_of_intention", ["student_id"], name: "forms_of_intention_student_id_fk", using: :btree

  create_table "issue_updates", primary_key: "UpdateID", force: true do |t|
    t.text     "UpdateName",                              null: false
    t.text     "Description",                             null: false
    t.integer  "Issues_IssueID",                          null: false
    t.integer  "tep_advisors_AdvisorBnum",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                  default: true, null: false
  end

  add_index "issue_updates", ["Issues_IssueID"], name: "fk_IssueUpdates_Issues1_idx", using: :btree
  add_index "issue_updates", ["tep_advisors_AdvisorBnum"], name: "fk_IssueUpdates_tep_advisors1_idx", using: :btree

  create_table "issues", primary_key: "IssueID", force: true do |t|
    t.integer  "student_id",                              null: false
    t.text     "Name",                                    null: false
    t.text     "Description",                             null: false
    t.boolean  "Open",                     default: true, null: false
    t.integer  "tep_advisors_AdvisorBnum",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                  default: true, null: false
  end

  add_index "issues", ["student_id"], name: "issues_student_id_fk", using: :btree
  add_index "issues", ["tep_advisors_AdvisorBnum"], name: "fk_Issues_tep_advisors1_idx", using: :btree

  create_table "item_levels", force: true do |t|
    t.integer  "assessment_item_id", null: false
    t.text     "descriptor"
    t.string   "level"
    t.integer  "ord"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_levels", ["assessment_item_id"], name: "item_levels_assessment_item_id_fk", using: :btree

  create_table "last_names", force: true do |t|
    t.integer  "student_id"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "last_names", ["student_id"], name: "last_names_student_id_fk", using: :btree

  create_table "majors", force: true do |t|
    t.string "name"
  end

  create_table "praxis_prep", primary_key: "TestID", force: true do |t|
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
    t.text    "Notes",               limit: 2147483647
  end

  add_index "praxis_prep", ["PraxisTest_TestCode"], name: "fk_PraxisPrep_PraxisTest1_idx", using: :btree
  add_index "praxis_prep", ["student_id"], name: "praxis_prep_student_id_fk", using: :btree

  create_table "praxis_results", force: true do |t|
    t.integer  "student_id",     null: false
    t.integer  "praxis_test_id"
    t.datetime "test_date"
    t.datetime "reg_date"
    t.string   "paid_by"
    t.integer  "test_score"
    t.integer  "best_score"
    t.integer  "cut_score"
  end

  add_index "praxis_results", ["praxis_test_id"], name: "fk_praxis_results_praxis_tests_idx", using: :btree
  add_index "praxis_results", ["student_id", "praxis_test_id", "test_date"], name: "index_by_stu_test_date", unique: true, using: :btree
  add_index "praxis_results", ["student_id"], name: "fk_praxis_results_students_idx", using: :btree

  create_table "praxis_subtest_results", force: true do |t|
    t.integer "praxis_result_id", null: false
    t.integer "sub_number"
    t.string  "name"
    t.integer "pts_earned"
    t.integer "pts_aval"
    t.integer "avg_high"
    t.integer "avg_low"
  end

  add_index "praxis_subtest_results", ["praxis_result_id"], name: "praxis_subtest_results_praxis_result_id_fk", using: :btree

  create_table "praxis_tests", force: true do |t|
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
  end

  add_index "praxis_tests", ["Program_ProgCode"], name: "fk_PraxisTest_Program1_idx", using: :btree
  add_index "praxis_tests", ["TestCode"], name: "TestCode_UNIQUE", unique: true, using: :btree

  create_table "praxis_updates", force: true do |t|
    t.datetime "report_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prog_exits", force: true do |t|
    t.integer  "student_id",                   null: false
    t.integer  "Program_ProgCode",             null: false
    t.integer  "ExitCode_ExitCode",            null: false
    t.integer  "ExitTerm",                     null: false
    t.datetime "ExitDate"
    t.float    "GPA",               limit: 24
    t.float    "GPA_last60",        limit: 24
    t.datetime "RecommendDate"
    t.text     "Details"
  end

  add_index "prog_exits", ["ExitCode_ExitCode"], name: "fk_Exit_ExitCode1_idx", using: :btree
  add_index "prog_exits", ["ExitTerm"], name: "prog_exits_ExitTerm_fk", using: :btree
  add_index "prog_exits", ["Program_ProgCode"], name: "fk_Exit__Program_idx", using: :btree
  add_index "prog_exits", ["student_id", "Program_ProgCode"], name: "index_prog_exits_on_student_id_and_Program_ProgCode", using: :btree

  create_table "programs", force: true do |t|
    t.string  "ProgCode",     limit: 10,  null: false
    t.string  "EPSBProgName", limit: 100
    t.string  "EDSProgName",  limit: 45
    t.boolean "Current"
  end

  add_index "programs", ["ProgCode"], name: "ProgCode_UNIQUE", unique: true, using: :btree

  create_table "roles", primary_key: "idRoles", force: true do |t|
    t.string "RoleName", limit: 45, null: false
  end

  add_index "roles", ["RoleName"], name: "RoleName_UNIQUE", unique: true, using: :btree

  create_table "student_files", force: true do |t|
    t.integer  "student_id",                                  null: false
    t.boolean  "active",                       default: true
    t.string   "doc_file_name",    limit: 100
    t.string   "doc_content_type", limit: 100
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
  end

  add_index "student_files", ["student_id"], name: "student_files_student_id_fk", using: :btree

  create_table "student_scores", force: true do |t|
    t.integer  "student_id",            null: false
    t.integer  "assessment_version_id", null: false
    t.integer  "assessment_item_id",    null: false
    t.integer  "item_level_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_scores", ["assessment_item_id"], name: "student_scores_assessment_item_id_fk", using: :btree
  add_index "student_scores", ["assessment_version_id"], name: "student_scores_assessment_version_id_fk", using: :btree
  add_index "student_scores", ["item_level_id"], name: "student_scores_item_level_id_fk", using: :btree
  add_index "student_scores", ["student_id"], name: "student_scores_student_id_fk", using: :btree

  create_table "students", force: true do |t|
    t.string  "Bnum",             limit: 9,   null: false
    t.string  "FirstName",        limit: 45,  null: false
    t.string  "PreferredFirst",   limit: 45
    t.string  "MiddleName",       limit: 45
    t.string  "LastName",         limit: 45,  null: false
    t.string  "PrevLast",         limit: 45
    t.string  "EnrollmentStatus", limit: 45
    t.string  "Classification",   limit: 45
    t.string  "CurrentMajor1",    limit: 45
    t.string  "concentration1"
    t.string  "CurrentMajor2",    limit: 45
    t.string  "concentration2"
    t.string  "CellPhone",        limit: 45
    t.string  "CurrentMinors",    limit: 45
    t.string  "Email",            limit: 100
    t.string  "CPO",              limit: 45
    t.text    "withdrawals"
    t.integer "term_graduated"
    t.string  "gender"
    t.string  "race"
    t.boolean "hispanic"
    t.integer "term_expl_major"
    t.integer "term_major"
  end

  add_index "students", ["Bnum"], name: "Bnum_UNIQUE", unique: true, using: :btree
  add_index "students", ["term_expl_major"], name: "students_term_expl_major_fk", using: :btree
  add_index "students", ["term_graduated"], name: "students_term_graduated_fk", using: :btree
  add_index "students", ["term_major"], name: "students_term_major_fk", using: :btree

  create_table "tep_advisors", force: true do |t|
    t.string  "AdvisorBnum", limit: 9,  null: false
    t.string  "Salutation",  limit: 45, null: false
    t.integer "user_id",                null: false
  end

  add_index "tep_advisors", ["AdvisorBnum"], name: "AdvisorBnum_UNIQUE", unique: true, using: :btree
  add_index "tep_advisors", ["user_id"], name: "tep_advisors_user_id_fk", using: :btree

  create_table "transcript", force: true do |t|
    t.integer "student_id",                    null: false
    t.string  "crn",               limit: 45,  null: false
    t.string  "course_code",       limit: 45,  null: false
    t.string  "course_name",       limit: 100
    t.integer "term_taken",                    null: false
    t.float   "grade_pt",          limit: 24
    t.string  "grade_ltr",         limit: 2
    t.float   "quality_points",    limit: 24
    t.float   "credits_attempted", limit: 24
    t.float   "credits_earned",    limit: 24
    t.string  "reg_status",        limit: 45
    t.string  "Inst_bnum",         limit: 45
    t.boolean "gpa_include",                   null: false
  end

  add_index "transcript", ["student_id", "crn", "term_taken"], name: "index_transcript_on_student_id_and_crn_and_term_taken", unique: true, using: :btree
  add_index "transcript", ["term_taken"], name: "fk_transcript_banner_terms1_idx", using: :btree

  create_table "users", force: true do |t|
    t.string  "UserName",      limit: 45, null: false
    t.string  "FirstName",     limit: 45, null: false
    t.string  "LastName",      limit: 45, null: false
    t.string  "Email",         limit: 45, null: false
    t.integer "Roles_idRoles",            null: false
  end

  add_index "users", ["Roles_idRoles"], name: "fk_users_Roles1_idx", using: :btree
  add_index "users", ["UserName"], name: "UserName_UNIQUE", unique: true, using: :btree

  Foreigner.load
  add_foreign_key "assessment_versions", "assessments", name: "assessment_versions_assessment_id_fk"

  add_foreign_key "banner_updates", "banner_terms", name: "banner_updates_end_term_fk", column: "end_term", primary_key: "BannerTerm"
  add_foreign_key "banner_updates", "banner_terms", name: "banner_updates_start_term_fk", column: "start_term", primary_key: "BannerTerm"

  add_foreign_key "clinical_assignments", "clinical_teachers", name: "clinical_assignments_clinical_teacher_id_fk"
  add_foreign_key "clinical_assignments", "students", name: "clinical_assignments_student_id_fk"

  add_foreign_key "clinical_teachers", "clinical_sites", name: "clinical_teachers_clinical_site_id_fk"

  add_foreign_key "employment", "students", name: "employment_student_id_fk"

  add_foreign_key "forms_of_intention", "majors", name: "forms_of_intention_major_id_fk"
  add_foreign_key "forms_of_intention", "students", name: "forms_of_intention_student_id_fk"

  add_foreign_key "issue_updates", "issues", name: "fk_IssueUpdates_Issues", column: "Issues_IssueID", primary_key: "IssueID"
  add_foreign_key "issue_updates", "tep_advisors", name: "issue_updates_tep_advisors_AdvisorBnum_fk", column: "tep_advisors_AdvisorBnum"

  add_foreign_key "issues", "students", name: "issues_student_id_fk"
  add_foreign_key "issues", "tep_advisors", name: "issues_tep_advisors_AdvisorBnum_fk", column: "tep_advisors_AdvisorBnum"

  add_foreign_key "item_levels", "assessment_items", name: "item_levels_assessment_item_id_fk"

  add_foreign_key "last_names", "students", name: "last_names_student_id_fk"

  add_foreign_key "praxis_prep", "praxis_tests", name: "praxis_prep_PraxisTest_TestCode_fk", column: "PraxisTest_TestCode"
  add_foreign_key "praxis_prep", "students", name: "praxis_prep_student_id_fk"

  add_foreign_key "praxis_results", "praxis_tests", name: "praxis_results_praxis_test_id_fk"
  add_foreign_key "praxis_results", "students", name: "praxis_results_student_id_fk"

  add_foreign_key "praxis_subtest_results", "praxis_results", name: "praxis_subtest_results_praxis_result_id_fk"

  add_foreign_key "praxis_tests", "programs", name: "praxis_tests_Program_ProgCode_fk", column: "Program_ProgCode"

  add_foreign_key "prog_exits", "banner_terms", name: "prog_exits_ExitTerm_fk", column: "ExitTerm", primary_key: "BannerTerm"
  add_foreign_key "prog_exits", "exit_codes", name: "prog_exits_ExitCode_ExitCode_fk", column: "ExitCode_ExitCode"
  add_foreign_key "prog_exits", "programs", name: "prog_exits_Program_ProgCode_fk", column: "Program_ProgCode"
  add_foreign_key "prog_exits", "students", name: "prog_exits_student_id_fk"

  add_foreign_key "student_files", "students", name: "student_files_student_id_fk"

  add_foreign_key "student_scores", "assessment_items", name: "student_scores_assessment_item_id_fk"
  add_foreign_key "student_scores", "assessment_versions", name: "student_scores_assessment_version_id_fk"
  add_foreign_key "student_scores", "item_levels", name: "student_scores_item_level_id_fk"
  add_foreign_key "student_scores", "students", name: "student_scores_student_id_fk"

  add_foreign_key "students", "banner_terms", name: "students_term_expl_major_fk", column: "term_expl_major", primary_key: "BannerTerm"
  add_foreign_key "students", "banner_terms", name: "students_term_graduated_fk", column: "term_graduated", primary_key: "BannerTerm"
  add_foreign_key "students", "banner_terms", name: "students_term_major_fk", column: "term_major", primary_key: "BannerTerm"

  add_foreign_key "tep_advisors", "users", name: "tep_advisors_user_id_fk"

  add_foreign_key "transcript", "banner_terms", name: "fk_transcript_banner_terms", column: "term_taken", primary_key: "BannerTerm"
  add_foreign_key "transcript", "students", name: "transcript_student_id_fk"

  add_foreign_key "users", "roles", name: "fk_users_Roles", column: "Roles_idRoles", primary_key: "idRoles"

end
