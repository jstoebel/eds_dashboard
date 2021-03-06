# == Schema Information
#
# Table name: adm_tep
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  Program_ProgCode      :integer          not null
#  BannerTerm_BannerTerm :integer          not null
#  Attempt               :integer
#  GPA                   :float(24)
#  GPA_last30            :float(24)
#  EarnedCredits         :integer
#  PortfolioPass         :boolean
#  TEPAdmit              :boolean
#  TEPAdmitDate          :datetime
#  Notes                 :text(65535)
#  student_file_id       :integer
#

# represents an admission to TEP
class AdmTep < ApplicationRecord
  self.table_name = 'adm_tep'

  include ApplicationHelper

  attr_accessor :fks_in, :adm_file

  belongs_to :program, {foreign_key: "Program_ProgCode"}
  belongs_to :student
  belongs_to :banner_term, {foreign_key: "BannerTerm_BannerTerm"}

  has_many :prog_exits, :through => :program

  has_many :adm_files, :dependent => :destroy
  has_many :student_files, :through => :adm_files

  #CALL BACKS
  after_validation :setters, :unless => Proc.new{|s| s.errors.any?}
  after_validation :complex_validations, :unless =>  Proc.new{|s| s.errors.any?}
  after_save :create_adm_file

  #SCOPES
  scope :admitted, lambda { where("TEPAdmit = ?", true)}
  #all of a student's open programs.
  scope :open, ->(student_id) {joins("LEFT JOIN prog_exits ON (adm_tep.Program_ProgCode = prog_exits.Program_ProgCode) and (adm_tep.student_id = prog_exits.student_id)").where("prog_exits.ExitCode_ExitCode IS NULL AND adm_tep.TEPAdmit = 1 AND adm_tep.student_id = ?", student_id)}

  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}   #all applications by term

  #BASIC VALIDATIONS

  validates_presence_of :student_id,
    :message => "No student selected."

  validates_presence_of :Program_ProgCode,
    :message => "No program selected."

  validates_presence_of :BannerTerm_BannerTerm,
    :message => "No term could be determined."

  validates_presence_of :TEPAdmitDate, {:message => "Admission date must be given.",
    :if => Proc.new{|s| s.TEPAdmit.present?}
  }

  def good_credits?
    return self.EarnedCredits.andand >= 30
  end

  def good_gpa?
    return (self.GPA.andand >= 2.75 or self.GPA_last30.andand >= 3.0)
  end

  #SETTERS

  def setters
    self.set_gpas
    self.set_credits
  end

  def set_gpas
    #set GPAs for record
    stu = self.student
    self.GPA = stu.gpa({:term => self.BannerTerm_BannerTerm})
    self.GPA_last30 = stu.gpa({:term => self.BannerTerm_BannerTerm, :last => 30})
  end


  def set_credits
    self.EarnedCredits = self.student.credits(self.BannerTerm_BannerTerm) unless self.errors.any?
  end

  #COMPLEX VALIDATIONS
  def complex_validations
    # these only run if all simple validations passed
    validations = [:admit_date_too_early, :admit_date_too_late, :bad_praxisI,
      :bad_gpa, :bad_credits, :cant_apply_again, :need_decision, :uniqueness_of_second_program,
      :meet_foundationals
    ]

    validations.each do |v|
      self.send(v)
    end
  end

  def admit_date_too_early
    if self.TEPAdmitDate.present? && self.TEPAdmitDate < self.banner_term.StartDate
      self.errors.add(:TEPAdmitDate, "Admission date must be after term begins.")
    end
  end

  def uniqueness_of_second_program
    stu = self.student
    # all of the student's adm_tep, where TEPAdmit = true or nil -> pull out program codes of each of these
    current_programs = stu.adm_tep.where("TEPAdmit = 1 or TEPAdmit is null").where(:Program_ProgCode => self.Program_ProgCode)

    #add error if there is more than one program found
    if current_programs.size > 1
      self.errors.add(:Program_ProgCode, "This student already has an accepted or pending application to this program")
    end
  end

  def admit_date_too_late
    if self.TEPAdmitDate.present? && self.TEPAdmitDate >= self.banner_term.next_term(exclusive=true).StartDate
      self.errors.add(:TEPAdmitDate, "Admission date must be before next term begins.")
    end
  end

  def bad_praxisI
    if self.TEPAdmit && !self.student.praxisI_pass
      self.errors.add(:base, "Student has not passed the Praxis I exam.")
    end
  end

  def bad_gpa
    if self.TEPAdmit && !self.good_gpa?
        self.errors.add(:base, "Student does not have sufficient GPA to be admitted this term.")
    end
  end

  def bad_credits
    if self.TEPAdmit && !self.good_credits?
      self.errors.add(:EarnedCredits, "Student needs to have earned 30 credit hours and has only earned #{self.EarnedCredits}.")
    end
  end

  def cant_apply_again

    attrs = self.attributes.slice("student_id", "Program_ProgCode")
    accepted_or_pending_apps = AdmTep.where(attrs).where("TEPAdmit = 1 or TEPAdmit IS NULL")
    if ( accepted_or_pending_apps.size > 0 && self.new_record? ||
         accepted_or_pending_apps.size > 1 && !self.new_record?
      )
      self.errors.add(:base, "Student has already been admitted or has an open application for this program in this term.")
    end
  end

  def need_decision
    if ((self.TEPAdmitDate.present? || self.student_file_id.present?) && self.TEPAdmit == nil )
      self.errors.add(:TEPAdmit, "Please make an admission decision for this student.")
    end
  end

  def meet_foundationals
    if self.new_record?
      begin
        if self.TEPAdmit && !self.completed_foundationals?
          self.errors.add(:base, "Student has not satisfied a foundational course.")
        end
      rescue NotImplementedError => e
        # can't handle these
        Rails.logger.warn e.message
        Rails.logger.warn e.backtrace
      end
    end
  end

  def create_adm_file
      if self.adm_file.present?
          AdmFile.create!({
              :student_file_id => self.adm_file.id,
              :adm_tep_id => self.id
          })
      end
  end


  def completed_foundationals?
    # returns if student has completed their foundational courses
    # throws NotImplementedError for Music PE and Health

    # EDS150: C or better
    # EDS227/228: B- or better, if applicable
    stu = self.student

    passed_150 =  stu
                    .transcripts
                    .where({:course_code => "EDS150"})
                    .where("grade_pt >= ?", 2.0)
                    .present?

    if self.program.ProgCode == '14'
      second_course = "EDS227"
    elsif ['40', '65', '28', '29', '23'].include? self.program.ProgCode
      # TODO:
        # Music's is MUS118B, but students can waive out of it.
          # we aren't yet sure how to handle the waiver so we are going to skip for now
        # pe: course not established

        raise NotImplementedError
    else
      # middle/secondary
      second_course = "EDS228"
    end

    passed_second = stu
                    .transcripts
                    .where({:course_code => second_course})
                    .where("grade_pt >= ?", 2.7)
                    .present?
    

    return passed_150 && passed_second

  end # completed_foundationals

end
