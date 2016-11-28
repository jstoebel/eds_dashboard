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

include Faker
FactoryGirl.define do
  factory :banner_term do
    BannerTerm do
      while true
        id = Number.between(111111, 999998)
        term = BannerTerm.find_by BannerTerm: id
        break if term.nil?
      end
      id
    end
    PlainTerm "A random term"
    StartDate Date.new(1855, 8, 1)
    EndDate Date.new(1855, 12, 15)
    AYStart 1855
  end
end
