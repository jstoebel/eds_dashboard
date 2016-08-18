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

class AdmTep < ActiveRecord::Base
  self.table_name = 'adm_tep'

  include ApplicationHelper

  attr_accessor :fks_in   #if forign keys are in.

  belongs_to :program, {foreign_key: "Program_ProgCode"}
  belongs_to :student
  belongs_to :banner_term, {foreign_key: "BannerTerm_BannerTerm"}
  belongs_to :student_file

  has_one :prog_exit, :through => :program

  #CALL BACKS
  before_validation :check_fks
  before_validation :set_gpas
  before_validation :set_credits

  #SCOPES
  scope :admitted, lambda { where("TEPAdmit = ?", true)}
  #all of a student's open programs.
  scope :open, ->(student_id) {joins("LEFT JOIN prog_exits ON (adm_tep.Program_ProgCode = prog_exits.Program_ProgCode) and (adm_tep.student_id = prog_exits.student_id)").where("prog_exits.ExitCode_ExitCode IS NULL AND adm_tep.TEPAdmit = 1 AND adm_tep.student_id = ?", student_id)}

  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}   #all applications by term

  #VALIDATIONS

  validate do |app|
    unless app.errors.any?
      term = BannerTerm.find(app.BannerTerm_BannerTerm)
      # next_term = BannerTerm.all.where("BannerTerm >?", app.BannerTerm_BannerTerm).order(:BannerTerm).first

      #the next non over lapping term
      next_term = BannerTerm.where("StartDate > ?", term.EndDate).order(:BannerTerm).first

      app.errors.add(:TEPAdmitDate, "Admission date must be given.") if app.TEPAdmit and app.TEPAdmitDate.blank?
      app.errors.add(:TEPAdmitDate, "Admission date must be after term begins.") if app.TEPAdmitDate and app.TEPAdmitDate < term.StartDate
      app.errors.add(:TEPAdmitDate, "Admission date must be before next term begins.") if app.TEPAdmitDate.present? and app.TEPAdmitDate >= next_term.StartDate

      app.errors.add(:base, "Student has not passed the Praxis I exam.") if app.TEPAdmit == true and not app.student.praxisI_pass
      app.errors.add(:base, "Student does not have sufficent GPA to be admitted this term.") if app.TEPAdmit and !good_gpa?

      app.errors.add(:EarnedCredits, "Student needs to have earned 30 credit hours and has only earned #{self.EarnedCredits}.") if app.TEPAdmit and (!app.good_credits?)

      #TODO must have completed EDS150 with C or better to be admitted.
      #TODO must complete 227, 227 or equivilant with a B- or better (what is the equvilant?)

      #can't create a duplicate application unless all others are denied
      #find any apps matching student, program and term that are accepted
      accepted_apps = AdmTep.where(student_id: app.student_id).where(Program_ProgCode: app.Program_ProgCode).where(BannerTerm_BannerTerm: app.BannerTerm_BannerTerm).where("TEPAdmit = 1 or TEPAdmit IS NULL")
      if accepted_apps.size > 0 and app.new_record?
        app.errors.add(:base, "Student has already been admitted or has an open applicaiton for this program in this term.")
      end

      #make sure that there isn't an open program for this student.
      open_programs = AdmTep.open(self.student_id).where(Program_ProgCode: self.Program_ProgCode)
      # if open_programs.size > 0 and app.new_record?
      #   self.errors.add(:base, "Student is already enrolled in this program." )
      # end

      # should validate for no admission decision if an admit date is given or letter is attached

      if ((self.TEPAdmitDate.present? || self.student_file_id.present?) && self.TEPAdmit == nil )
        self.errors.add(:TEPAdmit, "Please make an admission decision for this student.")
      end

    end
  end

  def set_gpas
    #set GPAs for record

    unless self.errors.any?
      stu = self.student
      self.GPA = stu.gpa({:term => self.BannerTerm_BannerTerm})
      self.GPA_last30 = stu.gpa({:term => self.BannerTerm_BannerTerm, :last => 30})
    end
  end


  def set_credits
    self.EarnedCredits = self.student.credits(self.BannerTerm_BannerTerm) unless self.errors.any?
  end

  def good_credits?
    return self.EarnedCredits >= 30
  end

  def good_gpa?
    return (self.GPA >= 2.75 or self.GPA_last30 >= 3.0)
  end

  private
  def check_fks
    #validate the foreign keys and return true if all are good
    self.errors.add(:student_id, "No student selected.") unless self.student_id.present?
    self.errors.add(:Program_ProgCode, "No program selected.") unless self.Program_ProgCode.present?
    self.errors.add(:BannerTerm_BannerTerm, "No term could be determined.") unless self.BannerTerm_BannerTerm.present?
    self.errors.add(:student_file_id, "Please attach an admission letter.") unless (self.student_file.present? or self.TEPAdmit == nil)
  end

end
