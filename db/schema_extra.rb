#
# Cherry pick migrations which are not incorporated 
# in the dumped db/schema.rb by rails (e.g. data loading).
# 
# To stage: 
# after each migration open the automatically dumped schema.rb 
# and add: 
#   require "db/schema_extra.rb" 
# before the last 'end'
#

require "db/migrate/012_create_example_user.rb"
CreateExampleUser.up