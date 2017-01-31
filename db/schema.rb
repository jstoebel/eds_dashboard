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

ActiveRecord::Schema.define(version: 20170131202113) do

  create_table "adm_files", force: :cascade do |t|
    t.integer  "adm_tep_id",      limit: 4
    t.integer  "student_file_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "adm_st", force: :cascade do |t|
    t.integer  "student_id",            limit: 4,     null: false
    t.integer  "BannerTerm_BannerTerm", limit: 4
    t.integer  "Attempt",               limit: 4
    t.float    "OverallGPA",            limit: 24
    t.float    "CoreGPA",               limit: 24
    t.boolean  "STAdmitted"
    t.datetime "STAdmitDate"
    t.integer  "STTerm",                limit: 4
    t.text     "Notes",                 limit: 65535
    t.boolean  "background_check"
    t.boolean  "beh_train"
    t.boolean  "conf_train"
    t.boolean  "kfets_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_file_id",       limit: 4
  end

  add_index "adm_st", ["BannerTerm_BannerTerm"], name: "fk_AdmST_BannerTerm1_idx", using: :btree
  add_index "adm_st", ["student_file_id"], name: "fk_rails_e532a76011", using: :btree
  add_index "adm_st", ["student_id"], name: "fk_rails_81f4e9ee93", using: :btree

  create_table "adm_tep", force: :cascade do |t|
    t.integer  "student_id",            limit: 4,     null: false
    t.integer  "Program_ProgCode",      limit: 4,     null: false
    t.integer  "BannerTerm_BannerTerm", limit: 4,     null: false
    t.integer  "Attempt",               limit: 4
    t.float    "GPA",                   limit: 24
    t.float    "GPA_last30",            limit: 24
    t.integer  "EarnedCredits",         limit: 4
    t.boolean  "PortfolioPass"
    t.boolean  "TEPAdmit"
    t.datetime "TEPAdmitDate"
    t.text     "Notes",                 limit: 65535
    t.integer  "student_file_id",       limit: 4
  end

  add_index "adm_tep", ["BannerTerm_BannerTerm"], name: "fk_AdmTEP_BannerTerm1_idx", using: :btree
  add_index "adm_tep", ["Program_ProgCode"], name: "fk_AdmTEP_Program1_idx", using: :btree
  add_index "adm_tep", ["student_file_id"], name: "fk_rails_065e9525b2", using: :btree
  add_index "adm_tep", ["student_id"], name: "fk_rails_967a6101da", using: :btree

  create_table "advisor_assignments", force: :cascade do |t|
    t.integer "student_id",     limit: 4, null: false
    t.integer "tep_advisor_id", limit: 4, null: false
  end

  add_index "advisor_assignments", ["student_id", "tep_advisor_id"], name: "index_advisor_assignments_on_student_id_and_tep_advisor_id", unique: true, using: :btree
  add_index "advisor_assignments", ["tep_advisor_id"], name: "fk_rails_a939fa1e55", using: :btree

  create_table "alumni_info", primary_key: "AlumniID", force: :cascade do |t|
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

  create_table "assessment_items", force: :cascade do |t|
    t.string   "slug",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
  end

  create_table "assessment_versions", force: :cascade do |t|
    t.integer  "assessment_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_versions", ["assessment_id"], name: "fk_rails_69aa91aaac", using: :btree

  create_table "assessments", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banner_terms", primary_key: "BannerTerm", force: :cascade do |t|
    t.string   "PlainTerm",     limit: 45, null: false
    t.datetime "StartDate",                null: false
    t.datetime "EndDate",                  null: false
    t.integer  "AYStart",       limit: 4,  null: false
    t.boolean  "standard_term"
  end

  create_table "banner_updates", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_term", limit: 4
    t.integer  "end_term",   limit: 4
  end

  add_index "banner_updates", ["end_term"], name: "fk_rails_2219dc81d4", using: :btree
  add_index "banner_updates", ["start_term"], name: "fk_rails_be69fdca92", using: :btree

  create_table "clinical_assignments", force: :cascade do |t|
    t.integer "student_id",          limit: 4,  null: false
    t.integer "clinical_teacher_id", limit: 4,  null: false
    t.integer "Term",                limit: 4,  null: false
    t.string  "Level",               limit: 45
    t.date    "StartDate"
    t.date    "EndDate"
    t.integer "transcript_id",       limit: 4
  end

  add_index "clinical_assignments", ["clinical_teacher_id"], name: "fk_ClinicalAssignments_ClinicalTeacher1_idx", using: :btree
  add_index "clinical_assignments", ["student_id"], name: "fk_rails_4eae3b4e55", using: :btree
  add_index "clinical_assignments", ["transcript_id"], name: "fk_rails_0f54585493", using: :btree

  create_table "clinical_sites", force: :cascade do |t|
    t.string "SiteName",     limit: 45,  null: false
    t.string "City",         limit: 45
    t.string "County",       limit: 45
    t.string "Principal",    limit: 45
    t.string "District",     limit: 45
    t.string "phone",        limit: 255
    t.string "receptionist", limit: 255
    t.string "website",      limit: 255
    t.string "email",        limit: 255
  end

  create_table "clinical_teachers", force: :cascade do |t|
    t.string   "Bnum",                limit: 45
    t.string   "FirstName",           limit: 45, null: false
    t.string   "LastName",            limit: 45, null: false
    t.string   "Email",               limit: 45
    t.string   "Subject",             limit: 45
    t.integer  "clinical_site_id",    limit: 4,  null: false
    t.integer  "Rank",                limit: 4
    t.integer  "YearsExp",            limit: 4
    t.datetime "begin_service"
    t.datetime "epsb_training"
    t.datetime "ct_record"
    t.datetime "co_teacher_training"
  end

  add_index "clinical_teachers", ["clinical_site_id"], name: "fk_ClinicalTeacher_ClinicalSite1_idx", using: :btree

  create_table "dispositions", force: :cascade do |t|
    t.string   "code",        limit: 255
    t.text     "description", limit: 65535
    t.boolean  "current"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "employment", force: :cascade do |t|
    t.integer  "student_id", limit: 4
    t.integer  "category",   limit: 4
    t.string   "employer",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employment", ["student_id"], name: "fk_rails_8b14daa8ce", using: :btree

  create_table "exit_codes", force: :cascade do |t|
    t.string "ExitCode",    limit: 5,  null: false
    t.string "ExitDiscrip", limit: 45, null: false
  end

  create_table "forms_of_intention", force: :cascade do |t|
    t.integer  "student_id",      limit: 4, null: false
    t.datetime "date_completing"
    t.boolean  "new_form"
    t.integer  "major_id",        limit: 4
    t.boolean  "seek_cert"
    t.boolean  "eds_only"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forms_of_intention", ["major_id"], name: "fk_rails_34628389e5", using: :btree
  add_index "forms_of_intention", ["student_id"], name: "fk_rails_21802f4afc", using: :btree

  create_table "issue_updates", primary_key: "UpdateID", force: :cascade do |t|
    t.text     "UpdateName",               limit: 65535,                null: false
    t.text     "Description",              limit: 65535,                null: false
    t.integer  "Issues_IssueID",           limit: 4,                    null: false
    t.integer  "tep_advisors_AdvisorBnum", limit: 4,                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                                default: true, null: false
    t.boolean  "addressed"
    t.string   "status",                   limit: 255
  end

  add_index "issue_updates", ["Issues_IssueID"], name: "fk_IssueUpdates_Issues1_idx", using: :btree
  add_index "issue_updates", ["tep_advisors_AdvisorBnum"], name: "fk_IssueUpdates_tep_advisors1_idx", using: :btree

  create_table "issues", primary_key: "IssueID", force: :cascade do |t|
    t.integer  "student_id",               limit: 4,                    null: false
    t.text     "Name",                     limit: 65535,                null: false
    t.text     "Description",              limit: 65535,                null: false
    t.integer  "tep_advisors_AdvisorBnum", limit: 4,                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                                default: true, null: false
    t.boolean  "positive"
    t.integer  "disposition_id",           limit: 4
  end

  add_index "issues", ["disposition_id"], name: "fk_rails_7e9ae84f98", using: :btree
  add_index "issues", ["student_id"], name: "fk_rails_ea791380de", using: :btree
  add_index "issues", ["tep_advisors_AdvisorBnum"], name: "fk_Issues_tep_advisors1_idx", using: :btree

  create_table "item_levels", force: :cascade do |t|
    t.integer  "assessment_item_id", limit: 4,     null: false
    t.text     "descriptor",         limit: 65535
    t.string   "level",              limit: 255
    t.integer  "ord",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cut_score"
  end

  add_index "item_levels", ["assessment_item_id"], name: "fk_rails_e6a2147994", using: :btree

  create_table "last_names", force: :cascade do |t|
    t.integer  "student_id", limit: 4
    t.string   "last_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "last_names", ["student_id"], name: "fk_rails_3940dc28b0", using: :btree

  create_table "majors", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "pgp_scores", force: :cascade do |t|
    t.integer  "pgp_id",       limit: 4
    t.integer  "goal_score",   limit: 4
    t.text     "score_reason", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pgp_scores", ["pgp_id"], name: "fk_rails_e14b2a6a06", using: :btree

  create_table "pgps", force: :cascade do |t|
    t.integer  "student_id",  limit: 4
    t.string   "goal_name",   limit: 255
    t.text     "description", limit: 65535
    t.text     "plan",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "strategies",  limit: 65535
  end

  add_index "pgps", ["student_id"], name: "fk_rails_4f8f978860", using: :btree

  create_table "praxis_prep", primary_key: "TestID", force: :cascade do |t|
    t.integer "student_id",          limit: 4,          null: false
    t.integer "PraxisTest_TestCode", limit: 4,          null: false
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
  end

  add_index "praxis_prep", ["PraxisTest_TestCode"], name: "fk_PraxisPrep_PraxisTest1_idx", using: :btree
  add_index "praxis_prep", ["student_id"], name: "fk_rails_4112037443", using: :btree

  create_table "praxis_result_temps", force: :cascade do |t|
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.integer  "student_id",     limit: 4
    t.integer  "praxis_test_id", limit: 4
    t.datetime "test_date"
    t.integer  "test_score",     limit: 4
    t.integer  "best_score",     limit: 4
  end

  create_table "praxis_results", force: :cascade do |t|
    t.integer  "student_id",     limit: 4,   null: false
    t.integer  "praxis_test_id", limit: 4
    t.datetime "test_date"
    t.datetime "reg_date"
    t.string   "paid_by",        limit: 255
    t.integer  "test_score",     limit: 4
    t.integer  "best_score",     limit: 4
  end

  add_index "praxis_results", ["praxis_test_id"], name: "fk_praxis_results_praxis_tests_idx", using: :btree
  add_index "praxis_results", ["student_id", "praxis_test_id", "test_date"], name: "index_by_stu_test_date", unique: true, using: :btree
  add_index "praxis_results", ["student_id"], name: "fk_praxis_results_students_idx", using: :btree

  create_table "praxis_sub_temps", force: :cascade do |t|
    t.integer "praxis_result_temp_id", limit: 4,   null: false
    t.integer "sub_number",            limit: 4
    t.string  "name",                  limit: 255
    t.integer "pts_earned",            limit: 4
    t.integer "pts_aval",              limit: 4
    t.integer "avg_high",              limit: 4
    t.integer "avg_low",               limit: 4
  end

  add_index "praxis_sub_temps", ["praxis_result_temp_id"], name: "fk_rails_c72a4ab38d", using: :btree

  create_table "praxis_subtest_results", force: :cascade do |t|
    t.integer "praxis_result_id", limit: 4,   null: false
    t.integer "sub_number",       limit: 4
    t.string  "name",             limit: 255
    t.integer "pts_earned",       limit: 4
    t.integer "pts_aval",         limit: 4
    t.integer "avg_high",         limit: 4
    t.integer "avg_low",          limit: 4
  end

  add_index "praxis_subtest_results", ["praxis_result_id"], name: "fk_rails_2b271e70f8", using: :btree

  create_table "praxis_tests", force: :cascade do |t|
    t.string  "TestCode",         limit: 45,  null: false
    t.string  "TestName",         limit: 255
    t.integer "CutScore",         limit: 4
    t.string  "TestFamily",       limit: 1
    t.string  "Sub1",             limit: 255
    t.string  "Sub2",             limit: 255
    t.string  "Sub3",             limit: 255
    t.string  "Sub4",             limit: 255
    t.string  "Sub5",             limit: 255
    t.string  "Sub6",             limit: 255
    t.string  "Sub7",             limit: 255
    t.integer "Program_ProgCode", limit: 4
    t.boolean "CurrentTest"
  end

  add_index "praxis_tests", ["Program_ProgCode"], name: "fk_PraxisTest_Program1_idx", using: :btree
  add_index "praxis_tests", ["TestCode"], name: "TestCode_UNIQUE", unique: true, using: :btree

  create_table "praxis_updates", force: :cascade do |t|
    t.datetime "report_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prog_exits", force: :cascade do |t|
    t.integer  "student_id",        limit: 4,     null: false
    t.integer  "Program_ProgCode",  limit: 4,     null: false
    t.integer  "ExitCode_ExitCode", limit: 4,     null: false
    t.integer  "ExitTerm",          limit: 4,     null: false
    t.datetime "ExitDate"
    t.float    "GPA",               limit: 24
    t.float    "GPA_last60",        limit: 24
    t.datetime "RecommendDate"
    t.text     "Details",           limit: 65535
  end

  add_index "prog_exits", ["ExitCode_ExitCode"], name: "fk_Exit_ExitCode1_idx", using: :btree
  add_index "prog_exits", ["ExitTerm"], name: "prog_exits_ExitTerm_fk", using: :btree
  add_index "prog_exits", ["Program_ProgCode"], name: "fk_Exit__Program_idx", using: :btree
  add_index "prog_exits", ["student_id", "Program_ProgCode"], name: "index_prog_exits_on_student_id_and_Program_ProgCode", using: :btree

  create_table "programs", force: :cascade do |t|
    t.string  "ProgCode",     limit: 10,  null: false
    t.string  "EPSBProgName", limit: 100
    t.string  "EDSProgName",  limit: 45
    t.boolean "Current"
    t.string  "license_code", limit: 255
  end

  add_index "programs", ["ProgCode"], name: "ProgCode_UNIQUE", unique: true, using: :btree

  create_table "roles", primary_key: "idRoles", force: :cascade do |t|
    t.string "RoleName", limit: 45, null: false
  end

  add_index "roles", ["RoleName"], name: "RoleName_UNIQUE", unique: true, using: :btree

  create_table "student_files", force: :cascade do |t|
    t.integer  "student_id",       limit: 4,                  null: false
    t.boolean  "active",                       default: true
    t.string   "doc_file_name",    limit: 100
    t.string   "doc_content_type", limit: 100
    t.integer  "doc_file_size",    limit: 4
    t.datetime "doc_updated_at"
  end

  add_index "student_files", ["student_id"], name: "fk_rails_78ba6603b4", using: :btree

  create_table "student_scores", force: :cascade do |t|
    t.integer  "student_id",            limit: 4, null: false
    t.integer  "assessment_version_id", limit: 4, null: false
    t.integer  "assessment_item_id",    limit: 4, null: false
    t.integer  "item_level_id",         limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_scores", ["assessment_item_id"], name: "fk_rails_e8e505d224", using: :btree
  add_index "student_scores", ["assessment_version_id"], name: "fk_rails_2ba42fd723", using: :btree
  add_index "student_scores", ["item_level_id"], name: "fk_rails_30b71fc0a4", using: :btree
  add_index "student_scores", ["student_id"], name: "fk_rails_076846734f", using: :btree

  create_table "students", force: :cascade do |t|
    t.string  "Bnum",                    limit: 9,     null: false
    t.string  "FirstName",               limit: 45,    null: false
    t.string  "PreferredFirst",          limit: 45
    t.string  "MiddleName",              limit: 45
    t.string  "LastName",                limit: 45,    null: false
    t.string  "PrevLast",                limit: 45
    t.string  "EnrollmentStatus",        limit: 45
    t.string  "Classification",          limit: 45
    t.string  "CurrentMajor1",           limit: 45
    t.string  "concentration1",          limit: 255
    t.string  "CurrentMajor2",           limit: 45
    t.string  "concentration2",          limit: 255
    t.string  "CellPhone",               limit: 45
    t.string  "CurrentMinors",           limit: 255
    t.string  "Email",                   limit: 100
    t.string  "CPO",                     limit: 45
    t.text    "withdraws",               limit: 65535
    t.integer "term_graduated",          limit: 4
    t.string  "gender",                  limit: 255
    t.string  "race",                    limit: 255
    t.boolean "hispanic"
    t.integer "term_expl_major",         limit: 4
    t.integer "term_major",              limit: 4
    t.string  "presumed_status",         limit: 255
    t.text    "presumed_status_comment", limit: 65535
  end

  add_index "students", ["Bnum"], name: "Bnum_UNIQUE", unique: true, using: :btree
  add_index "students", ["term_expl_major"], name: "fk_rails_f9760072bf", using: :btree
  add_index "students", ["term_graduated"], name: "fk_rails_0cb4e31ef0", using: :btree
  add_index "students", ["term_major"], name: "fk_rails_02beb2ceb0", using: :btree

  create_table "temp_foi", force: :cascade do |t|
    t.string   "student_id",      limit: 255
    t.string   "date_completing", limit: 255
    t.boolean  "new_form"
    t.integer  "major_id",        limit: 4
    t.boolean  "seek_cert"
    t.boolean  "eds_only"
    t.string   "foi_errors",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temp_foi", ["major_id"], name: "fk_rails_1885a219a7", using: :btree
  add_index "temp_foi", ["student_id"], name: "fk_rails_89ceaae199", using: :btree

  create_table "tep_advisors", force: :cascade do |t|
    t.string  "AdvisorBnum", limit: 9,   null: false
    t.string  "Salutation",  limit: 45,  null: false
    t.integer "user_id",     limit: 4
    t.string  "first_name",  limit: 255, null: false
    t.string  "last_name",   limit: 255, null: false
    t.string  "email",       limit: 255
  end

  add_index "tep_advisors", ["AdvisorBnum"], name: "AdvisorBnum_UNIQUE", unique: true, using: :btree
  add_index "tep_advisors", ["user_id"], name: "fk_rails_50ba8b67f4", using: :btree

  create_table "transcript", force: :cascade do |t|
    t.integer "student_id",        limit: 4,     null: false
    t.string  "crn",               limit: 45,    null: false
    t.string  "course_code",       limit: 45,    null: false
    t.string  "course_section",    limit: 255
    t.string  "course_name",       limit: 100
    t.integer "term_taken",        limit: 4,     null: false
    t.float   "grade_pt",          limit: 24
    t.string  "grade_ltr",         limit: 2
    t.float   "quality_points",    limit: 24
    t.float   "credits_attempted", limit: 24
    t.float   "credits_earned",    limit: 24
    t.string  "reg_status",        limit: 45
    t.text    "instructors",       limit: 65535
    t.boolean "gpa_include",                     null: false
  end

  add_index "transcript", ["student_id", "crn", "term_taken"], name: "index_transcript_on_student_id_and_crn_and_term_taken", unique: true, using: :btree
  add_index "transcript", ["term_taken"], name: "fk_transcript_banner_terms1_idx", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "UserName",      limit: 45,  null: false
    t.string  "FirstName",     limit: 45,  null: false
    t.string  "LastName",      limit: 45,  null: false
    t.string  "Email",         limit: 100, null: false
    t.integer "Roles_idRoles", limit: 4,   null: false
  end

  add_index "users", ["Roles_idRoles"], name: "fk_users_Roles1_idx", using: :btree
  add_index "users", ["UserName"], name: "UserName_UNIQUE", unique: true, using: :btree

  create_table "version_habtm_items", force: :cascade do |t|
    t.integer  "assessment_version_id", limit: 4, null: false
    t.integer  "assessment_item_id",    limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "version_habtm_items", ["assessment_item_id"], name: "fk_rails_5d2c803ddf", using: :btree
  add_index "version_habtm_items", ["assessment_version_id"], name: "fk_rails_c41fee807a", using: :btree

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
  add_foreign_key "assessment_versions", "assessments"
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
  add_foreign_key "item_levels", "assessment_items"
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
  add_foreign_key "student_scores", "assessment_items"
  add_foreign_key "student_scores", "assessment_versions"
  add_foreign_key "student_scores", "item_levels"
  add_foreign_key "student_scores", "students"
  add_foreign_key "students", "banner_terms", column: "term_expl_major", primary_key: "BannerTerm"
  add_foreign_key "students", "banner_terms", column: "term_graduated", primary_key: "BannerTerm"
  add_foreign_key "students", "banner_terms", column: "term_major", primary_key: "BannerTerm"
  add_foreign_key "temp_foi", "majors"
  add_foreign_key "temp_foi", "students", primary_key: "Bnum"
  add_foreign_key "tep_advisors", "users"
  add_foreign_key "transcript", "banner_terms", column: "term_taken", primary_key: "BannerTerm", name: "fk_transcript_banner_terms"
  add_foreign_key "transcript", "students"
  add_foreign_key "users", "roles", column: "Roles_idRoles", primary_key: "idRoles", name: "fk_users_Roles"
  add_foreign_key "version_habtm_items", "assessment_items"
  add_foreign_key "version_habtm_items", "assessment_versions"
end
