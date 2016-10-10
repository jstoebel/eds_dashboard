task :fix_adm_exit => :environment do
  data_source = Rails.root.join('entrance_exit_FIXED.csv')


  # for each row add an admission and exit (if applicable)

  begin
    AdmTep.transaction do

      # remove adm_tep for all those admitted.
      AdmTep.where({:TEPAdmit => true}).delete_all

      # remove all ProgExits
      ProgExit.delete_all

      row_num = 1

      CSV.foreach(data_source, :headers => true) do |row|
        row_num += 1
        bnum = row['CorrectedB#']
        puts "#{row_num}: processing #{bnum}"
        stu = Student.find_by :Bnum => bnum
        raise "could not find student with B# #{bnum}" if stu.nil?
        prog = Program.find_by :ProgCode => row["Program Code"]


        adm = AdmTep.new({:student_id => stu.id,
          :GPA => row["Admit GPA"].gsub("_", ""),
          :GPA_last30 => row["Last30GPA"],
          :TEPAdmit => true,
          :TEPAdmitDate => DateTime.strptime(row["Admit Date"], "%m/%d/%y")
        })

        adm.BannerTerm_BannerTerm = BannerTerm.current_term({exact: false, plan_b: :back, date: adm.TEPAdmitDate}).id
        raise "could not find program with code #{row["Program Code"]}" if prog.nil?
        adm.Program_ProgCode = prog.id
        adm.save!(:validate => false)

        if row["Exit Date"].present?

          prog_exit = ProgExit.new({:student_id => stu.id,
              :Program_ProgCode => prog.id,
              :ExitDate => DateTime.strptime(row["Exit Date"], "%m/%d/%y"),
              :GPA => row['Exit GPA']
          })

          e_code = ExitCode.find_by :ExitDiscrip => row["Exit Reason"]
          raise "can't find exit reason with code #{row["Exit Reason"]}" if e_code.nil?
          prog_exit.ExitCode_ExitCode = e_code.id
          prog_exit.ExitTerm = BannerTerm.current_term({exact: false, plan_b: :back, date: prog_exit.ExitDate}).id

          prog_exit.GPA = stu.gpa({:term => prog_exit.ExitTerm}) if prog_exit.GPA.blank?
          prog_exit.GPA_last60 = stu.gpa({:term => prog_exit.ExitTerm, :last => 60})
          prog_exit.save!(:validate => false)
        end # if prog_exit

        puts "\t -> done!"
      end # loop

      # raise "completed transaction!"
    end # transaction
  rescue => e
    puts e.message

  end


end
