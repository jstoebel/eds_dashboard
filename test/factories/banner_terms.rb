# == Schema Information
#
# Table name: banner_terms
#
#  BannerTerm :integer          not null, primary key
#  PlainTerm  :string(45)       not null
#  StartDate  :datetime         not null
#  EndDate    :datetime         not null
#  AYStart    :integer          not null
#

FactoryGirl.define do
  factory :banner_term do
    BannerTerm 185501
    PlainTerm "Fall 1855"
    StartDate Date.new(1855, 8, 1)
    EndDate Date.new(1855, 12, 15)
    AYStart 1855
  end
end
