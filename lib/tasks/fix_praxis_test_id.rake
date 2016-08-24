task :fix_test_id => :environment do
  PraxisResult.all.each do |result|
    ets_test_code = result.praxis_test_id
    real_code = PraxisTest.find_by({:TestCode => ets_test_code}).id
    result.praxis_test_id = real_code
    result.save!({:validate => false})
  end
end
