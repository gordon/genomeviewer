namespace :db do 
  namespace :default_data do 
    desc "Load default data in the database"
    task :load => :environment do
      puts "-- load default data in the tables"
      %w[styles graphical_elements feature_types].each do |k|
        data = YAML.load(IO.read "db/default_data/#{k}.yml")
        k.singularize.camelize.constantize.create(data)
      end
      puts "   -> done"
    end
  end
  namespace :example_user do 
    desc "Load default user in the database"
    task :load => :environment do 
      file = "db/default_data/example_user.yml"
      example_user = YAML.load(IO.read file)
      puts "-- create example user foo/foo"
      u = User.create(example_user)
      puts "   -> done"
      puts "-- upload gff3 files under test/gff3"
      filenames =  Dir.glob("test/gff3/**.gff3")
      filenames.each do |f|
        Annotation.new do |a|
          a.name = File.basename(f)
          a.user = u
          a.gff3_data = IO.read(f)
          a.save
        end
        puts "   -> #{File.basename(f)} uploaded"
      end
    end
  end
  desc "Create the db schema from schema.rb and loads default data"
  task :load => [:environment, "db:schema:load", "db:default_data:load"]
  desc "Create the db schema, loads default data and example user"
  task :load_with_foo => ["db:load", "db:example_user:load"]
end

