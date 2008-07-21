desc 'convert the storage from the id_file version to the id/file version'
task :convert_storage => :environment do 
   Dir.chdir("#{$GFF3_STORAGE_PATH}")
   Dir.glob('*').each do |file|
     file.match(/(\d*)_(.*)/)
     Dir.mkdir($1) rescue nil
     File.rename(file, "#{$1}/#{$2}")
   end
end