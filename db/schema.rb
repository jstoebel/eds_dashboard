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

ActiveRecord::Schema.define(version: 20150716145436) do

  create_table "adm_st", primary_key: "AppID", force: true do |t|
    t.string   "Student_Bnum",          limit: 9,  null: false
    t.integer  "BannerTerm_BannerTerm"
    t.float    "OverallGPA",            limit: 24
    t.float    "CoreGPA",               limit: 24
    t.boolean  "STAdmitted"
    t.datetime "STAdmitDate"
    t.integer  "STTerm"
  end

  add_index "adm_st", ["BannerTerm_BannerTerm"], name: "fk_AdmST_BannerTerm1_idx", using: :btree
  add_index "adm_st", ["Student_Bnum"], name: "fk_AdmST_Student1_idx", using: :btree

  create_table "adm_tep", primary_key: "AppID", force: true do |t|
    t.string   "Student_Bnum",          limit: 9,  null: false
    t.string   "Program_ProgCode",      limit: 45, null: false
    t.integer  "BannerTerm_BannerTerm",            null: false
    t.float    "GPA",                   limit: 24
    t.float    "GPA_last30",            limit: 24
    t.integer  "EarnedCredits"
    t.boolean  "PortfolioPass"
    t.boolean  "TEPAdmit"
    t.datetime "TEPAdmitDate"
    t.text     "Notes"
  end

  add_index "adm_tep", ["BannerTerm_BannerTerm"], name: "fk_AdmTEP_BannerTerm1_idx", using: :btree
  add_index "adm_tep", ["Program_ProgCode"], name: "fk_AdmTEP_Program1_idx", using: :btree
  add_index "adm_tep", ["Student_Bnum"], name: "fk_AdmTEP_Student1_idx", using: :btree

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

  create_table "clinical_assignments", primary_key: "AssignmentID", force: true do |t|
    t.string  "Student_Bnum",                      limit: 9,  null: false
    t.integer "ClinicalTeacher_idClinicalTeacher",            null: false
    t.integer "Term",                                         null: false
    t.string  "CourseID",                          limit: 45, null: false
    t.string  "Level",                             limit: 45
  end

  add_index "clinical_assignments", ["ClinicalTeacher_idClinicalTeacher"], name: "fk_ClinicalAssignments_ClinicalTeacher1_idx", using: :btree
  add_index "clinical_assignments", ["Student_Bnum"], name: "fk_ClinicalAssignments_Student1_idx", using: :btree

  create_table "clinical_sites", primary_key: "idClinicalSite", force: true do |t|
    t.string "SiteName",  limit: 45, null: false
    t.string "City",      limit: 45
    t.string "County",    limit: 45
    t.string "Principal", limit: 45
    t.string "District",  limit: 45
  end

  create_table "clinical_teachers", primary_key: "idClinicalTeacher", force: true do |t|
    t.string  "FirstName",                   limit: 45, null: false
    t.string  "LastName",                    limit: 45, null: false
    t.string  "Email",                       limit: 45
    t.string  "Subject",                     limit: 45
    t.integer "ClinicalSite_idClinicalSite",            null: false
  end

  add_index "clinical_teachers", ["ClinicalSite_idClinicalSite"], name: "fk_ClinicalTeacher_ClinicalSite1_idx", using: :btree

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
  end

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

  create_table "praxis_tests", primary_key: "PraxisTest_TestCode", force: true do |t|
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

  create_table "prog_exits", primary_key: "ExitID", force: true do |t|
    t.string   "Student_Bnum",      limit: 9,  null: false
    t.string   "Program_ProgCode",  limit: 45, null: false
    t.string   "ExitCode_ExitCode", limit: 45, null: false
    t.integer  "ExitTerm"
    t.datetime "CompleteDate"
    t.float    "GPA",               limit: 24
    t.float    "GPA_last60",        limit: 24
    t.datetime "RecomendDate"
  end

  add_index "prog_exits", ["ExitCode_ExitCode"], name: "fk_Exit_ExitCode1_idx", using: :btree
  add_index "prog_exits", ["Program_ProgCode"], name: "fk_Exit__Program_idx", using: :btree
  add_index "prog_exits", ["Student_Bnum"], name: "fk_Exit_Student1_idx", using: :btree

  create_table "programs", primary_key: "ProgCode", force: true do |t|
    t.string  "EPSBProgName", limit: 45
    t.string  "EDSProgName",  limit: 45
    t.boolean "Current"
  end

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
  end

  create_table "tep_advisors", primary_key: "AdvisorBnum", force: true do |t|
    t.string "FirstName",  limit: 45, null: false
    t.string "LastName",   limit: 45, null: false
    t.string "Email",      limit: 45, null: false
    t.string "Salutation", limit: 45, null: false
  end

  create_table "users", id: false, force: true do |t|
    t.string "UserName",               limit: 45, null: false
    t.string "Password",               limit: 45, null: false
    t.string "FirstName",              limit: 45, null: false
    t.string "LastName",               limit: 45, null: false
    t.string "Email",                  limit: 45, null: false
    t.string "TEPAdvisor_AdvisorBnum", limit: 45, null: false
  end

  add_index "users", ["TEPAdvisor_AdvisorBnum"], name: "fk_User_TEPAdvisor1_idx", using: :btree

end
