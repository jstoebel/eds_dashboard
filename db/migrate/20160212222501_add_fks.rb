class AddFks < ActiveRecord::Migration
  def up
    #add every FK in the database!
    add_foreign_key "advisor_assignments", "tep_advisors", name: "advisor_assignments_tep_advisors_AdvisorBnum_fk", column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"
    add_foreign_key "clinical_assignments", "clinical_teachers", name: "clinical_assignments_clinical_teacher_id_fk"
    add_foreign_key "clinical_assignments", "students", name: "fk_ClinicalAssignments_Student", column: "Bnum", primary_key: "Bnum"
    add_foreign_key "clinical_teachers", "clinical_sites", name: "clinical_teachers_clinical_site_id_fk"
    add_foreign_key "praxis_tests", "programs", name: "fk_PraxisTest_Program", column: "Program_ProgCode", primary_key: "ProgCode"
    add_foreign_key "praxis_results", "students", name: "fk_PraxisResult_Student", column: "Bnum", primary_key: "Bnum"
    add_foreign_key "praxis_results", "praxis_tests", name: "fk_PraxisResult_PraxisTest", column: "TestCode", primary_key: "TestCode"
    add_foreign_key "adm_tep", "students", name: "fk_AdmTEP_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "adm_tep", "banner_terms", name: "fk_AdmTEP_BannerTerm", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm"
    add_foreign_key "adm_st", "students", name: "fk_AdmST_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "adm_st", "banner_terms", name: "fk_AdmST_BannerTerm", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm"
    add_foreign_key "prog_exits", "students", name: "fk_Exit_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "prog_exits", "programs", name: "fk_Exit__Program", column: "Program_ProgCode", primary_key: "ProgCode"
    add_foreign_key "prog_exits", "exit_codes", name: "fk_Exit_ExitCode", column: "ExitCode_ExitCode", primary_key: "ExitCode"
    add_foreign_key "users", "roles", name: "fk_users_Roles", column: "Roles_idRoles", primary_key: "idRoles"
    add_foreign_key "tep_advisors", "users", name: "fk_tep_advisors_users" ,column: "username", primary_key: "UserName"
    add_foreign_key "praxis_subtest_results", "praxis_results", name: "fk_praxis_subtest_results_praxis_results", column: "praxis_results_TestID", primary_key: "TestID"
    add_foreign_key "employment", "students", name: "fk_Employment_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "forms_of_intention", "students", name: "fk_FormofIntention_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "praxis_prep", "students", name: "fk_PraxisPrep_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "praxis_prep", "praxis_tests", name: "fk_PraxisPrep_PraxisTest", column: "PraxisTest_TestCode", primary_key: "TestCode"
    add_foreign_key "alumni_info", "students", name: "fk_AlumniInfo_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "issues", "students", name: "fk_Issues_students", column: "students_Bnum", primary_key: "Bnum"
    add_foreign_key "issues", "tep_advisors", name: "fk_Issues_tep_advisors", column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"
    add_foreign_key "issue_updates", "issues",  name: "fk_IssueUpdates_Issues", column: "Issues_IssueID", primary_key: "IssueID"
    add_foreign_key "issue_updates", "tep_advisors", name: "fk_IssueUpdates_tep_advisors", column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"
    add_foreign_key "student_files", "students", name: "fk_student_files_students", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "advisor_assignments", "students", name: "fk_students_has_tep_advisors_students", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "advisor_assignments", "tep_advisors", name: "fk_students_has_tep_advisors_tep_advisors",  column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"
    add_foreign_key "transcript", "students", name: "fk_transcript_students", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "transcript", "banner_terms", name: "fk_transcript_banner_terms", column: "term_taken", primary_key: "BannerTerm"
  end

  def down
      #TODO!
  end

end
