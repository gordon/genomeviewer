require File.dirname(__FILE__) + '/../test_helper'

module ExampleAnnotations
     
  # some users to save the annotations:
    
  john_smith = User.create({
    :name => "John Smith",
    :password => "goodpassword",
    :email => "genome@viewer.org"
  }) 
   
  jane_doe = User.create({
    :name => "Jane Doe",
    :password => "mypassword",
    :email => "jane@gviewer.org"
  }) 

  encode_known_genes = Annotation.new do |a|
    a.name = "encode_known_genes_Mar07.gff3"
    a.user = User.find_by_name("John Smith")
    a.description = "Encode known genes, March 2007\nA test gff3 file from genometools."
    a.gff3_data = IO.read("test/gff3/encode_known_genes_Mar07.gff3")
    a.save
  end

  standard_gene_1 = Annotation.new do |a|
    a.name = "standard_gene_with_introns_as_tree.gff3"
    a.user = User.find_by_name("Jane Doe")
    # no description
    a.gff3_data = IO.read("test/gff3/standard_gene_with_introns_as_tree.gff3")
    a.save
  end
  
end

class AnnotationTest < Test::Unit::TestCase
    
  include ExampleAnnotations
  
  def test_annotation_create
    @a = Annotation.create(:name => "test1", :user_id => 1, :gff3_data=>"testtesttest")
    @b = Annotation.create(:gff3_data=>"another test",:name => "test2", :user_id => 1)
    assert @a
    assert @b
  end

  def test_filesystem_upload_1
    uploaded_encode_known_genes = $GFF3_STORAGE_PATH+"/"+\
                         User.find_by_name("John Smith").id.to_s+\
                         "_encode_known_genes_Mar07.gff3"
    assert File.exists?(uploaded_encode_known_genes)
  end

  def test_filesystem_upload_2
    uploaded_standard_gene_1 = $GFF3_STORAGE_PATH+"/"+\
                         User.find_by_name("Jane Doe").id.to_s+\
                         "_standard_gene_with_introns_as_tree.gff3"    
    assert File.exists?(uploaded_standard_gene_1)
  end

  def test_upload_content_1
    path_of_encode_known_genes = $GFF3_STORAGE_PATH+"/"+\
                         User.find_by_name("John Smith").id.to_s+\
                         "_encode_known_genes_Mar07.gff3"
    f = File.open(path_of_encode_known_genes)
    first_two_lines = f.gets + f.gets
    assert_equal first_two_lines,
      "##gff-version   3\n##sequence-region   chr1 147971134 148468994\n"
  end

  def test_upload_content_2
    original_file = "test/gff3/standard_gene_with_introns_as_tree.gff3"
    uploaded_file = $GFF3_STORAGE_PATH+"/"+\
                         User.find_by_name("Jane Doe").id.to_s+\
                         "_standard_gene_with_introns_as_tree.gff3"  
    assert_equal IO.read(original_file), 
                 IO.read(uploaded_file)
   end
             
  def test_rename
    standard_gene_1 = Annotation.find_by_name("standard_gene_with_introns_as_tree.gff3")
    old_location = $GFF3_STORAGE_PATH+"/"+\
                         User.find_by_name("Jane Doe").id.to_s+\
                         "_standard_gene_with_introns_as_tree.gff3"  
                         
    standard_gene_1.name = "standard_gene_1"
    
#    assert_equal standard_gene_1.gff3_data_storage, old_location
    
    new_location = $GFF3_STORAGE_PATH+"/"+\
                         User.find_by_name("Jane Doe").id.to_s+\
                         "_standard_gene_1"    
    standard_gene_1.save
    assert File.exists?(new_location)
    standard_gene_1.name = "standard_gene_with_introns_as_tree.gff3"  
    standard_gene_1.save
    assert File.exists?(old_location)
  end
  
  def test_seq_id_modification

    little1 = Annotation.new do |a|
      a.name = "little1.gff3"
      a.user = User.find_by_name("Jane Doe")
      a.gff3_data = IO.read("test/gff3/little1.gff3")
      a.save
    end
    
    seq_region_test1_changed = SequenceRegion.new do |sr|
      sr.seq_id = "test1"
      sr.seq_begin = 2000
      sr.seq_end = 8000
    end
    
    little1.sequence_regions=[seq_region_test1_changed]
    little1.save
    assert little1.sequence_regions[0].seq_begin=2000
    assert little1.sequence_regions[0].seq_end=8000
  end
  
end
