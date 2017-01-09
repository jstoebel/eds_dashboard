# == Schema Information
#
# Table name: banner_terms
#
#  BannerTerm    :integer          not null, primary key
#  PlainTerm     :string(45)       not null
#  StartDate     :datetime         not null
#  EndDate       :datetime         not null
#  AYStart       :integer          not null
#  standard_term :boolean
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
    StartDate Date.new(1950, 8, 1)
    EndDate Date.new(1950, 12, 15)
    AYStart 1950
  end
end
