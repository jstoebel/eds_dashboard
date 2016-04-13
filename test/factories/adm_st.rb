FactoryGirl.define do
  factory :adm_st do
    before(:create) {
      adm_tep = FactoryGirl.create :adm_tep
    }

    #make the adm_st for the same student who has this adm_tep!

  end
end