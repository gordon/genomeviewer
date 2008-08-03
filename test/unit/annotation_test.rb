require File.dirname(__FILE__) + '/../test_helper'

class AnnotationTest < Test::Unit::TestCase
    
  def setup    
    # be sure the necessary storage and tmp directory exist
    Dir.mkdir($GFF3_STORAGE_PATH) rescue nil
    Dir.mkdir("tmp/gff3_data") rescue nil
    # delete all users and create some test ones
    User.destroy_all
    u1 = User.create!(:username => "u1", :name => "Uu 1", 
                      :password => "...",:email => "u1@x.xxx") 
    u2 = User.create!(:username => "u2", :name => "Uu 2", 
                      :password => "...",:email => "u2@x.xxx") 
  end
    
  def test_new_method
    u1 = User.find_by_username("u1")
    a1 = Annotation.new do |a|
      a.gff3_data = IO.read("test/gff3/little1.gff3")
      # gff3_data saved before a name and user is available
      # should have landed in the tmp/gff3_data directory
      assert File.exist?(a.gff3_data_storage)
      assert_equal "tmp/gff3_data", File.dirname(a.gff3_data_storage)
      a.user = u1
      a.description = "A little annotation"
      a.name = "little1.gff3"
      a.save
      # now an user and name were available, so after saving it should 
      # have been moved to the storage directory
      assert File.exist?(a.gff3_data_storage)
      assert_equal "#{$GFF3_STORAGE_PATH}/#{u1.id}", File.dirname(a.gff3_data_storage)
    end
  end
  
  def test_create_method 
    u2 = User.find_by_username("u2")
    little2 = IO.read("test/gff3/little2.gff3")
    a2 = Annotation.create( 
          :user => u2, 
          :gff3_data => little2,
          :name =>  "little2.gff3")
    assert File.exist?(a2.gff3_data_storage)
    assert_equal "#{$GFF3_STORAGE_PATH}/#{u2.id}", File.dirname(a2.gff3_data_storage)
    assert_equal little2, IO.read("#{$GFF3_STORAGE_PATH}/#{u2.id}/little2.gff3")
    assert_equal little2, a2.gff3_data
  end
  
  def test_non_standard_type
    t = "test_type"
    # check that t is not global otherwise this test has no sense
    assert !FeatureClass.global.map(&:name).include?(t)
    
    gff3_data = IO.read("test/gff3/little1.gff3")
    # change "gene" in the non standard type
    gff3_data = gff3_data.gsub("gene", t)
    # upload the modified annotation
    u = User.find(:first)
    assert !u.own_feature_classes.map(&:name).include?(t)
    a = Annotation.create(:name => "~deleteme",
                          :user => u,
                          :gff3_data => gff3_data)
    assert u.own_feature_classes.map(&:name).include?(t)
    # note: 
    # in the current implementation, feature classes are 
    # *not* deleted when the annotation that caused their
    # creation is deleted
    a.destroy
    assert u.own_feature_classes.map(&:name).include?(t)
    # however they are deleted if the user is deleted
    u.destroy
    assert_nil FeatureClass.find_by_user_id(u.id)
  end
  
  def test_unique_name_validation
    u1 = User.find_by_username("u1")
    u2 = User.find_by_username("u2")
    gff3 = IO.read("test/gff3/little1.gff3")
    # upload it the first time for u1
    a1 = Annotation.create(:name => "little1.gff3",
                      :user => u1, :gff3_data => gff3)
    # try to upload it the second time for u1 with the same name
    assert_nil Annotation.create(:name => "little1.gff3",
                      :user => u1, :gff3_data => gff3).id
    # upload it for u2 with the same name used for u1
    assert_not_nil Annotation.create(:name => "little1.gff3",
                      :user => u2, :gff3_data => gff3).id
    # delete the first copy for u1 and retry to upload
    a1.destroy
    assert_not_nil Annotation.create(:name => "little1.gff3",
                      :user => u1, :gff3_data => gff3).id
    
  end
  
end
