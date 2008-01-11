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

  def test_filesystem_upload_1
    uploaded_encode_known_genes = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("John Smith").id.to_s+\
                         "/encode_known_genes_Mar07.gff3"
    assert File.exists?(uploaded_encode_known_genes)
  end

  def test_filesystem_upload_2
    uploaded_standard_gene_1 = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("Jane Doe").id.to_s+\
                         "/standard_gene_with_introns_as_tree.gff3"    
    assert File.exists?(uploaded_standard_gene_1)
  end

  def test_upload_content_1
    path_of_encode_known_genes = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("John Smith").id.to_s+\
                         "/encode_known_genes_Mar07.gff3"
    f = File.open(path_of_encode_known_genes)
    first_two_lines = f.gets + f.gets
    assert_equal first_two_lines,
      "##gff-version   3\n##sequence-region   chr1 147971134 148468994\n"
  end

  def test_upload_content_2
    original_file = "test/gff3/standard_gene_with_introns_as_tree.gff3"
    uploaded_file = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("Jane Doe").id.to_s+\
                         "/standard_gene_with_introns_as_tree.gff3"  
    assert_equal IO.read(original_file), 
                 IO.read(uploaded_file)
   end
             
  def test_private_to_public_and_back
    standard_gene_1 = Annotation.find_by_name("standard_gene_with_introns_as_tree.gff3")
    old_location = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("Jane Doe").id.to_s+\
                         "/standard_gene_with_introns_as_tree.gff3"  
    standard_gene_1.public = true
    new_location = $GFF3_STORAGE_PATH+"/"+\
                         "public/"+User.find_by_name("Jane Doe").id.to_s+\
                         "/standard_gene_with_introns_as_tree.gff3"    
    assert File.exists?(new_location)
    standard_gene_1.public = false
    assert File.exists?(old_location)
  end       

  def test_file_rename
    standard_gene_1 = Annotation.find_by_name("standard_gene_with_introns_as_tree.gff3")
    old_location = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("Jane Doe").id.to_s+\
                         "/standard_gene_with_introns_as_tree.gff3"  
    standard_gene_1.name = "standard_gene_1"
    new_location = $GFF3_STORAGE_PATH+"/"+\
                         "private/"+User.find_by_name("Jane Doe").id.to_s+\
                         "/standard_gene_1"    
    assert File.exists?(new_location)
    standard_gene_1.name = "standard_gene_with_introns_as_tree.gff3"  
    assert File.exists?(old_location)
  end
  
end
