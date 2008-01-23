class CreateFeatureClasses < ActiveRecord::Migration
  def self.up
    create_table :feature_classes do |t|
      t.string :name
    end
    
    FeatureClass.create(:name => "gene")
    FeatureClass.create(:name => "exon")
    FeatureClass.create(:name => "intron")
    FeatureClass.create(:name => "CDS")
    FeatureClass.create(:name => "mRNA")
    FeatureClass.create(:name => "TF_binding_site")
    FeatureClass.create(:name => "repeat_region")
    FeatureClass.create(:name => "long_terminal_repeat")
    FeatureClass.create(:name => "LTR_retrotransposon")
    FeatureClass.create(:name => "inverted_repeat")
    FeatureClass.create(:name => "target_site_duplication")
    
  end

  def self.down
    drop_table :feature_classes
  end
end
