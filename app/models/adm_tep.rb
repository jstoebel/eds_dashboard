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
  after_validation :setters, :unless => Proc.new{|s| s.errors.any?}
  after_validation :complex_validations, :unless =>  Proc.new{|s| s.errors.any?}

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

  validates_presence_of :student_file_id,{:message => "Please attach an admission letter.",
      :unless => Proc.new{|s| s.TEPAdmit.nil?}
    }

  validates_presence_of :TEPAdmitDate, {:message => "Admission date must be given.",
    :unless => Proc.new{|s| s.TEPAdmit.nil?}# self.TEPAdmit.nil?
  }

  def good_credits?
    return self.EarnedCredits >= 30
  end

  def good_gpa?
    return (self.GPA >= 2.75 or self.GPA_last30 >= 3.0)
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
      :bad_gpa, :bad_credits, :cant_apply_again, :need_decision
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

  def admit_date_too_late
    if self.TEPAdmitDate.present? && self.TEPAdmitDate >= self.banner_term.next_term.StartDate
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
        self.errors.add(:base, "Student does not have sufficent GPA to be admitted this term.")
    end
  end

  def bad_credits
    if self.TEPAdmit && !self.good_credits?
      self.errors.add(:EarnedCredits, "Student needs to have earned 30 credit hours and has only earned #{self.EarnedCredits}.")
    end
  end

  def cant_apply_again

    attrs = self.attributes.slice("student_id", "Program_ProgCode", "BannerTerm_BannerTerm")
    accepted_or_pending_apps = AdmTep.where(attrs).where("TEPAdmit = 1 or TEPAdmit IS NULL")
    if accepted_or_pending_apps.size > 0 && self.new_record?
      self.errors.add(:base, "Student has already been admitted or has an open applicaiton for this program in this term.")
    end
  end

  def need_decision
    if ((self.TEPAdmitDate.present? || self.student_file_id.present?) && self.TEPAdmit == nil )
      self.errors.add(:TEPAdmit, "Please make an admission decision for this student.")
    end
  end

end
