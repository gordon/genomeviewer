#
# Cherry pick from migrations data loading and schema modifications 
# not included in the dumped db/schema.rb by rails.
# 
# To stage: 
# after each migration open the automatically dumped schema.rb 
# and add: 
#   require "db/schema_extra.rb" 
# before the last 'end'
#

%w[gene exon intron CDS mRNA TF_binding_site repeat_region long_terminal_repeat
LTR_retrotransposon inverted_repeat target_site_duplication ].each  do |fclass|
  FeatureClass.create(:name => fclass)
end
%w[stroke stroke_marked track_title].each do |g_el|
  GraphicalElement.create(:name => g_el)
end
%w[line box caret dashed].each {|s| Style.create(:name => s)}

require "db/migrate/012_create_example_user.rb"
CreateExampleUser.up
