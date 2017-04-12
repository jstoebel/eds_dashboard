class StudentScoreUpload < ActiveRecord::Base

  has_many :student_scores
  has_many :student_score_temps
end
