# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text(65535)      not null
#  Description              :text(65535)      not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  addressed                :boolean
#  status                   :string(255)
#
class IssueUpdate < ApplicationRecord
  belongs_to :issue, foreign_key: 'Issues_IssueID'
  belongs_to :tep_advisor, foreign_key: 'tep_advisors_AdvisorBnum'
  after_validation :add_addressed
  after_create :creation_alert

  scope :sorted, -> { order(created_at: :desc) }

  BNUM_REGEX = /\AB00\d{6}\Z/i

  # the possible statuses for an issue update and coorsponding attrs
  STATUSES = { resolved: { name: 'resolved', status_color: :success,
                           resolved: true },
               progressing: { name: 'progressing', status_color: :warning,
                              resolved: false },
               concern: { name: 'concern', status_color: :danger,
                          resolved: false } }.freeze

  validates :UpdateName,
            presence: { message: 'Please provide an update name.' }

  validates :Description,
            presence: { message: 'Please provide an update description.' }

  validates :tep_advisors_AdvisorBnum,
            presence: { message: 'Could not find an advisor profile for this '\
                                 'user.' }

  validates :status,
            presence: { message: 'Please select a status for this update' },
            inclusion: { in: STATUSES.keys.map(&:to_s), message: 'Invalid '\
                                                                 'status name' }

  validates :addressed,
            inclusion: { in: [true, false],
                         message: 'addressed may not be nil' }

  def student
    # fetch the owning sudent
    issue.student
  end

  def status_color
    # what color should be displayed for this update
    STATUSES[status.to_sym][:status_color]
  end

  def resolves?
    # does this update resolve the issue?
    STATUSES[status.to_sym][:resolved]
  end

  private

  def add_addressed
    # all new issue_updates are not addressed
    self.addressed = false if new_record?
  end

  def creation_alert
    # alert advisors re: the creation of this update
    # email all advisors, instructors and admins
    stu = student
    recipients = [] # array of tep_advisors to email
    # advisors
    recipients += stu.tep_advisors
    recipients += stu.tep_instructors
    recipients += TepAdvisor.all.select { |adv| adv.user.andand.is? 'admin' }
    recipients.uniq!

    recipients.each do |r|
      IssueUpdateMailer.alert_new(stu, r).deliver_now
    end
  end
end
