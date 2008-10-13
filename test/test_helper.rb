ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  
  #
  # As the storage is not only DB-based, i.e. annotations are saved as files,
  # it is difficult to make use only of fixtures. This helper method uploads
  # an annotation for an user, so that you have: 
  #
  # - @_u => an user, with one annotation
  # - @_a => annotation
  # - @_sr => sequence region
  # - @_ft => feature type
  # - @_c => configuration
  # - @_f => format
  #
  def user_setup
    @_u = User.create(:username => "_user", 
                      :password => "_pass",
                      :name => "_user",
                      :email => "an_user@test.tst")
    @_u.reset_configuration
    @_c = @_u.configuration
    @_f = @_c.format
    @_a = Annotation.create(:gff3_data => IO.read("test/gff3/little1.gff3"),
                            :name => "_little1.gff3",
                            :user => @_u)
    @_sr = @_a.sequence_regions[0]
    @_ft = @_a.feature_types[0]
    return true
  rescue
    return false
  end

end
