# == Schema Information
#
# Table name: praxis_results
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  praxis_test_id :integer
#  test_date      :datetime
#  reg_date       :datetime
#  paid_by        :string(255)
#  test_score     :integer
#  best_score     :integer
#

# an instance of a student taking a praxis exam

class PraxisResult < ApplicationRecord

  attr_accessor :from_ets  #if this record is coming from ETS and should therefor
  # not expect some validations

  #callbacks
  before_validation :check_alterability, :unless => :from_ets
  before_validation :check_unique
  before_destroy :check_alterability, :uneless => :from_ets

  belongs_to :student
  has_many :praxis_subtest_results
  belongs_to :praxis_test

  validates :student_id,
    presence: {message: "Please select a student."}

  validates :praxis_test_id,
    presence: {message: "Test must be selected."}

  validates :test_date,
    presence: {message: "Test date must be selected."}

  validates :reg_date,
    unless: :from_ets,
    presence: {message: "Registration date must be selected."}

  validates :paid_by,
    unless: :from_ets,
    presence: {message: "Payment source must be given."},
    inclusion: {
      :in => ['EDS', 'ETS (fee waiver)', 'Student'],
      message: "Invalid payment source.",
      allow_blank: true}


  def can_alter?
    #if this test record may be altered.
    #if a score has been recorded for this record, it can't be changed.
    return true if self.new_record?
    db_record = PraxisResult.find(self.id)
    return db_record.test_score.blank?
  end

  def AltID
    return self.id
  end

  def cut_score
    # this method replaces a previously existing column and instead looks to the
    #  results test for the cut score.
    return self.praxis_test.andand.CutScore
  end

  def passing?
    # has the exam been passed?
    if self.test_score.blank? or self.cut_score.blank?
      return false
    else
      return self.test_score >= self.cut_score
    end
  end

  private

    def check_unique
      # student can't take the test twice on the same dat
      matching_ids = PraxisResult.where(
        student_id: self.student_id,
        praxis_test_id: self.praxis_test_id,
        test_date: self.test_date
         )

      if matching_ids.size > 1
        self.errors.add(:base, "Student may not take the same exam on the same day.")
      end
    end

    def check_alterability
      # can only alter the test (edit or destroy) if no scores exist
      if !self.can_alter?
        self.errors.add(:base, "Test has scores and may not be altered.")
        throw :abort
      end
      return true
    end

end
