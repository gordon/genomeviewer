class CreateExampleUser < ActiveRecord::Migration
  
  def self.up
    unless ENV["RAILS_ENV"] == "production"
      
      say_with_time "Creating an example user \n (email: foo@bar.com, password: foo)" do 
        User.new do |u|
          u.email = "foo@bar.com"
          u.name = "Foo Bar"
          u.password = "foo"
          u.save
        end
      end
       
      say_with_time "Uploading all files under test/gff3...\n(this takes a while)" do 
        example_files = Dir.new("test/gff3").map - [".","..","readme"]    
        example_files.each do |example|
          Annotation.new do |a|
            a.name = example
            a.user = User.find_by_email("foo@bar.com")
            a.gff3_data = IO.read("test/gff3/"+example)
            a.save
          end
        end
      end
      
    else
        
      say "Doing nothing... no example user is created in production environment"
      
    end
    
  end

  def self.down
    unless ENV["RAILS_ENV"] == "production"
      say_with_time "Destroying example user and all its dependent records..." do 
        User.find_by_email("foo@bar.com").destroy
      end
    else        
        say "Doing nothing... no example user in production environment!"
    end
  end
  
end
