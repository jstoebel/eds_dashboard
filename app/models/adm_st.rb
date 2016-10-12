# == Schema Information
#
# Table name: adm_st
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  BannerTerm_BannerTerm :integer
#  Attempt               :integer
#  OverallGPA            :float(24)
#  CoreGPA               :float(24)
#  STAdmitted            :boolean
#  STAdmitDate           :datetime
#  STTerm                :integer
#  Notes                 :text(65535)
#  background_check      :boolean
#  beh_train             :boolean
#  conf_train            :boolean
#  kfets_in              :boolean
#  created_at            :datetime
#  updated_at            :datetime
#  student_file_id       :integer
#

class AdmSt < ActiveRecord::Base
  self.table_name = 'adm_st'
  include ApplicationHelper

	attr_accessor :skip_val_letter

  belongs_to :student
  belongs_to :banner_term, foreign_key: "BannerTerm_BannerTerm"
  belongs_to :student_file

	scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}

  #CALL BACKS
  after_validation :setters, :unless => Proc.new{|s| s.errors.any?}
  after_validation :complex_validations, :unless =>  Proc.new{|s| s.errors.any?}

  #BASIC VALIDATIONS
  validates_presence_of :student_id,
    :message => "No student selected."

  validates_presence_of :BannerTerm_BannerTerm,
    :message => "No term could be determined."

  validates_presence_of :student_file_id,{:message => "Please attach an admission letter.",
    :unless => Proc.new{|s| s.STAdmitted.nil?}
  }

  validates_presence_of :STAdmitDate, {:message => "Admission date must be given.",
    :if => Proc.new{|s| s.STAdmitted}
  }

  validates_presence_of :STAdmitted, {:message => "Please make an admission decision for this student.",
    :unless => Proc.new{|s| s.STAdmitDate.nil?}
  }

  def good_gpa?
    #  does student have a sufficient GPA
    # NOTE: as of 9/21/16 it is not possible to compute the core GPA.
    # This method does not include it
    return (self.OverallGPA.andand >= 2.75)
  end

  def setters
    self.set_overall_gpa
    self.set_core_gpa
  end

  def set_overall_gpa
    #set GPAs for record
    stu = self.student
    self.OverallGPA = stu.gpa({:term => self.BannerTerm_BannerTerm})
  end

  def set_core_gpa
    #TODO
  end

  private

  def complex_validations
    # these only run if all simple validations passed
    validations = [:admit_date_too_early, :admit_date_too_late, :cant_apply_again
    ]
    validations.each do |v|
      self.send(v)
    end
  end

  def admit_date_too_early
    if self.STAdmitDate && self.STAdmitDate < self.banner_term.StartDate
      self.errors.add(:STAdmitDate, "Admission date must be after term begins.")
    end
  end

  def admit_date_too_late
    if self.STAdmitDate and self.STAdmitDate >= self.banner_term.next_term(exclusive=true).StartDate
      self.errors.add(:STAdmitDate, "Admission date may not be after next term begins.")
    end
  end

  def cant_apply_again
    non_rejected_apps = AdmSt.where({student_id: self.student_id,
        BannerTerm_BannerTerm: self.BannerTerm_BannerTerm})
      .where("STAdmitted = 1 or STAdmitted IS NULL")

    if non_rejected_apps.size > 0 and self.new_record?
      self.errors.add(:base, "Student has already been admitted or has an open applicaiton in this term.")
    end
  end

end
