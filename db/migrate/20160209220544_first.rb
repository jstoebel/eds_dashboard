class First < ActiveRecord::Migration
  def change
  create_table "adm_st", force: true do |t|
    t.string   "Student_Bnum",          limit: 9,   null: false
    t.integer  "BannerTerm_BannerTerm"
    t.integer  "Attempt",                           null: false
    t.float    "OverallGPA",            limit: 24
    t.float    "CoreGPA",               limit: 24
    t.boolean  "STAdmitted"
    t.datetime "STAdmitDate"
    t.integer  "STTerm"
    t.text     "Notes"
    t.string   "letter_file_name",      limit: 100
    t.string   "letter_content_type",   limit: 100
    t.integer  "letter_file_size"
    t.datetime "letter_updated_at"
    t.boolean  "background_check"
    t.boolean  "beh_train"
    t.boolean  "conf_train"
    t.boolean  "kfets_in"
  end

  add_index "adm_st", ["BannerTerm_BannerTerm"], name: "fk_AdmST_BannerTerm1_idx", using: :btree
  add_index "adm_st", ["Student_Bnum"], name: "fk_AdmST_Student1_idx", using: :btree

  create_table "adm_tep", force: true do |t|
    t.string   "Student_Bnum",          limit: 9,   null: false
    t.string   "Program_ProgCode",      limit: 45,  null: false
    t.integer  "BannerTerm_BannerTerm",             null: false
    t.integer  "Attempt",                           null: false
    t.float    "GPA",                   limit: 24
    t.float    "GPA_last30",            limit: 24
    t.integer  "EarnedCredits"
    t.boolean  "PortfolioPass"
    t.boolean  "TEPAdmit"
    t.datetime "TEPAdmitDate"
    t.text     "Notes"
    t.string   "letter_file_name",      limit: 100
    t.string   "letter_content_type",   limit: 500
    t.integer  "letter_file_size"
    t.datetime "letter_updated_at"
  end

  add_index "adm_tep", ["BannerTerm_BannerTerm"], name: "fk_AdmTEP_BannerTerm1_idx", using: :btree
  add_index "adm_tep", ["Program_ProgCode"], name: "fk_AdmTEP_Program1_idx", using: :btree
  add_index "adm_tep", ["Student_Bnum"], name: "fk_AdmTEP_Student1_idx", using: :btree

  create_table "advisor_assignments", id: false, force: true do |t|
    t.string "students_Bnum",            limit: 9, null: false
    t.string "tep_advisors_AdvisorBnum", limit: 9, null: false
  end

  add_index "advisor_assignments", ["students_Bnum"], name: "fk_students_has_tep_advisors_students1_idx", using: :btree
  add_index "advisor_assignments", ["tep_advisors_AdvisorBnum"], name: "fk_students_has_tep_advisors_tep_advisors1_idx", using: :btree

  create_table "alumni_info", primary_key: "AlumniID", force: true do |t|
    t.string    "Student_Bnum", limit: 9,  null: false
    t.timestamp "Date"
    t.string    "FirstName",    limit: 45
    t.string    "LastName",     limit: 45
    t.string    "Email",        limit: 45
    t.string    "Phone",        limit: 45
    t.string    "Address1",     limit: 45
    t.string    "Address2",     limit: 45
    t.string    "City",         limit: 45
    t.string    "State",        limit: 45
    t.string    "ZIP",          limit: 45
  end

  add_index "alumni_info", ["Student_Bnum"], name: "fk_AlumniInfo_Student1_idx", using: :btree

  create_table "banner_terms", primary_key: "BannerTerm", force: true do |t|
    t.string   "PlainTerm", limit: 45, null: false
    t.datetime "StartDate",            null: false
    t.datetime "EndDate",              null: false
    t.integer  "AYStart",              null: false
  end

  create_table "banner_updates", primary_key: "UploadDate", force: true do |t|
  end

  create_table "clinical_assignments", force: true do |t|
    t.string  "Bnum",                limit: 9,  null: false
    t.integer "clinical_teacher_id",            null: false
    t.integer "Term",                           null: false
    t.string  "CourseID",            limit: 45, null: false
    t.string  "Level",               limit: 45
    t.date    "StartDate"
    t.date    "EndDate"
    t.integer "AltID",                          null: false
  end

  add_index "clinical_assignments", ["AltID"], name: "AltID_UNIQUE", unique: true, using: :btree
  add_index "clinical_assignments", ["Bnum"], name: "fk_ClinicalAssignments_Student1_idx", using: :btree
  add_index "clinical_assignments", ["clinical_teacher_id"], name: "fk_ClinicalAssignments_ClinicalTeacher1_idx", using: :btree

  create_table "clinical_sites", force: true do |t|
    t.string "SiteName",  limit: 45, null: false
    t.string "City",      limit: 45
    t.string "County",    limit: 45
    t.string "Principal", limit: 45
    t.string "District",  limit: 45
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
    t.date   "EmpDate",                 null: false
    t.string "Student_Bnum", limit: 45, null: false
    t.string "EmpCategory",  limit: 45
    t.string "Employer",     limit: 45
  end

  add_index "employment", ["Student_Bnum"], name: "fk_Employment_1_idx", using: :btree

  create_table "exit_codes", primary_key: "ExitCode", force: true do |t|
    t.string "ExitDiscrip", limit: 45, null: false
  end

  create_table "forms_of_intention", primary_key: "FormID", force: true do |t|
    t.string  "Student_Bnum",   limit: 9,  null: false
    t.string  "DateCompleting", limit: 45, null: false
    t.boolean "NewForm"
    t.boolean "SeekCert"
    t.string  "CertArea",       limit: 45
  end

  add_index "forms_of_intention", ["Student_Bnum"], name: "fk_FormofIntention_Student1_idx", using: :btree

  create_table "issue_updates", primary_key: "UpdateID", force: true do |t|
    t.timestamp "CreateDate",                           null: false
    t.string    "UpdateName",               limit: 100, null: false
    t.text      "Description",                          null: false
    t.integer   "Issues_IssueID",                       null: false
    t.string    "tep_advisors_AdvisorBnum", limit: 45,  null: false
  end

  add_index "issue_updates", ["Issues_IssueID"], name: "fk_IssueUpdates_Issues1_idx", using: :btree
  add_index "issue_updates", ["tep_advisors_AdvisorBnum"], name: "fk_IssueUpdates_tep_advisors1_idx", using: :btree

  create_table "issues", primary_key: "IssueID", force: true do |t|
    t.timestamp "CreateDate",                                          null: false
    t.string    "students_Bnum",            limit: 9,                  null: false
    t.string    "Name",                     limit: 100,                null: false
    t.text      "Description",                                         null: false
    t.boolean   "Open",                                 default: true, null: false
    t.string    "tep_advisors_AdvisorBnum", limit: 45,                 null: false
  end

  add_index "issues", ["students_Bnum"], name: "fk_Issues_students1_idx", using: :btree
  add_index "issues", ["tep_advisors_AdvisorBnum"], name: "fk_Issues_tep_advisors1_idx", using: :btree

  create_table "praxis_prep", primary_key: "TestID", force: true do |t|
    t.string  "Student_Bnum",        limit: 9,          null: false
    t.string  "PraxisTest_TestCode", limit: 45,         null: false
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
  add_index "praxis_prep", ["Student_Bnum"], name: "fk_PraxisPrep_Student1_idx", using: :btree

  create_table "praxis_results", primary_key: "TestID", force: true do |t|
    t.string   "Bnum",      limit: 9,  null: false
    t.string   "TestCode",  limit: 45, null: false
    t.datetime "TestDate"
    t.datetime "RegDate"
    t.string   "PaidBy",    limit: 45
    t.integer  "TestScore"
    t.integer  "BestScore"
    t.integer  "CutScore"
    t.boolean  "Pass"
    t.integer  "AltID",                null: false
  end

  add_index "praxis_results", ["AltID"], name: "AltID_UNIQUE", unique: true, using: :btree
  add_index "praxis_results", ["Bnum"], name: "fk_PraxisResult_Student1_idx", using: :btree
  add_index "praxis_results", ["TestCode"], name: "fk_PraxisResult_PraxisTest1_idx", using: :btree

  create_table "praxis_subtest_results", primary_key: "SubTestID", force: true do |t|
    t.string  "SubNumber",             limit: 45, null: false
    t.string  "praxis_results_TestID", limit: 45, null: false
    t.string  "Name",                  limit: 45
    t.integer "PtsEarned"
    t.integer "PtsAval"
    t.integer "AvgHigh"
    t.integer "AvgLow"
  end

  add_index "praxis_subtest_results", ["praxis_results_TestID"], name: "fk_praxis_subtest_results_praxis_results1_idx", using: :btree

  create_table "praxis_tests", primary_key: "TestCode", force: true do |t|
    t.string  "TestName",         limit: 45
    t.integer "CutScore"
    t.string  "TestFamily",       limit: 1
    t.string  "Sub1",             limit: 100
    t.string  "Sub2",             limit: 100
    t.string  "Sub3",             limit: 100
    t.string  "Sub4",             limit: 100
    t.string  "Sub5",             limit: 100
    t.string  "Sub6",             limit: 100
    t.string  "Sub7",             limit: 45
    t.string  "Program_ProgCode", limit: 45
    t.boolean "CurrentTest"
  end

  add_index "praxis_tests", ["Program_ProgCode"], name: "fk_PraxisTest_Program1_idx", using: :btree

  create_table "praxis_updates", primary_key: "ReportDate", force: true do |t|
    t.datetime "UploadDate", null: false
  end

  create_table "prog_exits", id: false, force: true do |t|
    t.integer  "id",                           null: false
    t.string   "Student_Bnum",      limit: 9,  null: false
    t.string   "Program_ProgCode",  limit: 45, null: false
    t.string   "ExitCode_ExitCode", limit: 45, null: false
    t.integer  "ExitTerm",                     null: false
    t.datetime "ExitDate"
    t.float    "GPA",               limit: 24
    t.float    "GPA_last60",        limit: 24
    t.datetime "RecommendDate"
    t.text     "Details"
  end

  add_index "prog_exits", ["ExitCode_ExitCode"], name: "fk_Exit_ExitCode1_idx", using: :btree
  add_index "prog_exits", ["Program_ProgCode"], name: "fk_Exit__Program_idx", using: :btree
  add_index "prog_exits", ["Student_Bnum"], name: "fk_Exit_Student1_idx", using: :btree
  add_index "prog_exits", ["id"], name: "id", using: :btree

  create_table "programs", primary_key: "ProgCode", force: true do |t|
    t.string  "EPSBProgName", limit: 45
    t.string  "EDSProgName",  limit: 45
    t.boolean "Current"
  end

  create_table "roles", primary_key: "idRoles", force: true do |t|
    t.string "RoleName", limit: 45, null: false
  end

  add_index "roles", ["RoleName"], name: "RoleName_UNIQUE", unique: true, using: :btree

  create_table "student_files", force: true do |t|
    t.string   "Student_Bnum",     limit: 9,                  null: false
    t.boolean  "active",                       default: true
    t.string   "doc_file_name",    limit: 100
    t.string   "doc_content_type", limit: 100
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
  end

  add_index "student_files", ["Student_Bnum"], name: "fk_student_files_students1_idx", using: :btree

  create_table "students", primary_key: "Bnum", force: true do |t|
    t.string  "FirstName",        limit: 45,                          null: false
    t.string  "PreferredFirst",   limit: 45
    t.string  "MiddleName",       limit: 45
    t.string  "LastName",         limit: 45,                          null: false
    t.string  "PrevLast",         limit: 45
    t.string  "ProgStatus",       limit: 45,  default: "Prospective"
    t.string  "EnrollmentStatus", limit: 45
    t.string  "Classification",   limit: 45
    t.string  "CurrentMajor1",    limit: 45
    t.string  "CurrentMajor2",    limit: 45
    t.integer "TermMajor"
    t.string  "PraxisICohort",    limit: 45
    t.string  "PraxisIICohort",   limit: 45
    t.string  "CellPhone",        limit: 45
    t.string  "CurrentMinors",    limit: 45
    t.string  "Email",            limit: 100
    t.string  "CPO",              limit: 45
    t.integer "AltID",                                                null: false
  end

  add_index "students", ["AltID"], name: "AltID_UNIQUE", unique: true, using: :btree

  create_table "tep_advisors", primary_key: "AdvisorBnum", force: true do |t|
    t.string "Salutation", limit: 45, null: false
    t.string "username",   limit: 45, null: false
  end

  add_index "tep_advisors", ["AdvisorBnum"], name: "AdvisorBnum_UNIQUE", unique: true, using: :btree
  add_index "tep_advisors", ["username"], name: "fk_tep_advisors_users1_idx", using: :btree

  create_table "transcript", primary_key: "crn", force: true do |t|
    t.string  "students_Bnum",     limit: 9,   null: false
    t.string  "course_code",       limit: 45,  null: false
    t.string  "course_name",       limit: 100
    t.integer "term_taken",                    null: false
    t.float   "grade_pt",          limit: 24
    t.string  "grade_ltr",         limit: 2
    t.float   "quality_points",    limit: 24
    t.float   "credits_attempted", limit: 24
    t.float   "credits_earned",    limit: 24
    t.float   "gpa_credits",       limit: 24
    t.string  "reg_status",        limit: 45
    t.string  "Inst_bnum",         limit: 45
  end

  add_index "transcript", ["students_Bnum"], name: "fk_transcript_students1_idx", using: :btree
  add_index "transcript", ["term_taken"], name: "fk_transcript_banner_terms1_idx", using: :btree

  create_table "users", primary_key: "UserName", force: true do |t|
    t.string  "FirstName",     limit: 45, null: false
    t.string  "LastName",      limit: 45, null: false
    t.string  "Email",         limit: 45, null: false
    t.integer "Roles_idRoles",            null: false
  end

  add_index "users", ["Roles_idRoles"], name: "fk_users_Roles1_idx", using: :btree
  	
  end
end
