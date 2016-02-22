task :load_constants => :environment do
    require 'yaml'
    pattern = Rails.root + "db/seed/*.yaml"
    Dir[pattern].each do |path| #iterate all yaml files in this directory
      
      #get the file's name (w/o extension and load it)
      full_name = File.basename path
      ext = File.extname  path
      name = File.basename path, ext
      f = File.new(path)
      records = YAML.load_file(f)

      records = YAML.load_file(f)

      model = name.classify.constantize
      puts "creating records in #{name.classify}"
      records.each do |rec|
        model.delete_all # clear all records and start over
        puts %Q(    #{rec})
        model.create! rec

      end

    end
end