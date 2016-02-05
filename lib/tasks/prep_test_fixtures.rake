namespace :db do
  namespace :fixtures do
 		task :prep_test_fixtures => :environment do

			model_names = ['banner_term', 'exit_code']
			models =[]
			model_names.each do |m|
				Dir.glob(Rails.root.to_s + "/app/models/#{m}.rb").map do |s|
					models.push Pathname.new(s).basename.to_s.gsub(/\.rb$/, '').camelize
				end

			end


				models.each do |mod|

					model = mod.constantize
					next unless model.ancestors.include?(ActiveRecord::Base)

					puts "Dumping model: " + mod
					entries = model.all

					increment = 1

					fixtures_file = Rails.root.to_s + '/test/fixtures/' + mod.underscore.pluralize
					# puts fixtures_file
					File.open(fixtures_file, 'w') do |f|
						entries.each do |e|
							attrs = e.attributes		#grab the attributes for an instance
							attrs.delete_if{|k,v| v.blank?}		#delete the attribute if its value is blank

							output = {mod + "_" + increment.to_s => attrs}	#name of a yaml entry mapped to its attributes
							f << output.to_yaml.gsub(/^--- \n/, '') + "\n"		#deleting "--- \n"
							increment += 1
						end
					end

				end


		end
	end
end

