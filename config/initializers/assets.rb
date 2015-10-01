# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Dir.entries("./app/assets/javascripts").each do |js|
	if js.include? "js"		#filtering out "." and ".."
		Rails.application.config.assets.precompile += [js[0..-8]]
	end
end
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
