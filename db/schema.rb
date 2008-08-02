# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 17) do

  create_table "annotations", :force => true do |t|
    t.string  "name",        :default => "",    :null => false
    t.integer "user_id",     :default => 0,     :null => false
    t.text    "description"
    t.boolean "public",      :default => false, :null => false
    t.boolean "add_introns", :default => true,  :null => false
  end

  create_table "collapsing_configurations", :force => true do |t|
    t.integer "user_id"
    t.text    "to_parent"
  end

  create_table "color_configurations", :force => true do |t|
    t.integer "user_id"
    t.integer "element_id"
    t.string  "element_type"
    t.decimal "red"
    t.decimal "green"
    t.decimal "blue"
  end

  create_table "dominated_features", :force => true do |t|
    t.integer "domination_configuration_id"
    t.integer "feature_class_id"
  end

  create_table "domination_configurations", :force => true do |t|
    t.integer "user_id"
    t.integer "dominator_id"
  end

  create_table "drawing_format_configurations", :force => true do |t|
    t.integer "user_id"
    t.integer "width",               :default => 800
    t.decimal "margins",             :default => 30.0
    t.decimal "bar_height",          :default => 15.0
    t.decimal "bar_vspace",          :default => 10.0
    t.decimal "track_vspace",        :default => 10.0
    t.decimal "scale_arrow_width",   :default => 6.0
    t.decimal "scale_arrow_height",  :default => 10.0
    t.decimal "arrow_width",         :default => 6.0
    t.decimal "stroke_width",        :default => 0.5
    t.decimal "stroke_marked_width", :default => 1.5
    t.boolean "show_grid",           :default => true
  end

  create_table "feature_classes", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "feature_style_configurations", :force => true do |t|
    t.integer "user_id"
    t.integer "feature_class_id"
    t.integer "style_id"
  end

  create_table "graphical_elements", :force => true do |t|
    t.string "name"
  end

  create_table "sequence_regions", :force => true do |t|
    t.string  "seq_id",        :default => "", :null => false
    t.integer "annotation_id", :default => 0,  :null => false
    t.integer "seq_begin",     :default => 0,  :null => false
    t.integer "seq_end",       :default => 0,  :null => false
    t.text    "description"
  end

  create_table "styles", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string  "password",                 :limit => 40, :default => "", :null => false
    t.string  "name",                     :limit => 64, :default => "", :null => false
    t.string  "email",                    :limit => 64, :default => "", :null => false
    t.string  "institution",                            :default => ""
    t.string  "url",                                    :default => ""
    t.integer "public_annotations_count",               :default => 0,  :null => false
    t.string  "username",                 :limit => 64, :default => "", :null => false
  end

end
