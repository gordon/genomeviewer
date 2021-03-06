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

ActiveRecord::Schema.define(:version => 30) do

  create_table "annotations", :force => true do |t|
    t.string  "name",        :default => "",    :null => false
    t.integer "user_id",     :default => 0,     :null => false
    t.text    "description"
    t.boolean "public",      :default => false, :null => false
    t.boolean "add_introns", :default => true,  :null => false
  end

  create_table "configurations", :force => true do |t|
    t.integer "user_id"
    t.integer "width",   :default => 800, :null => false
  end

  create_table "feature_type_in_annotations", :force => true do |t|
    t.integer "annotation_id"
    t.integer "feature_type_id"
    t.integer "max_show_width"
    t.integer "max_capt_show_width"
  end

  create_table "feature_types", :force => true do |t|
    t.string  "name"
    t.float   "fill_red"
    t.float   "fill_green"
    t.float   "fill_blue"
    t.float   "stroke_red"
    t.float   "stroke_green"
    t.float   "stroke_blue"
    t.float   "stroke_marked_red"
    t.float   "stroke_marked_green"
    t.float   "stroke_marked_blue"
    t.integer "style_key"
    t.boolean "collapse_to_parent"
    t.boolean "split_lines"
    t.integer "max_capt_show_width"
    t.integer "max_num_lines"
    t.integer "configuration_id"
    t.integer "max_show_width"
  end

  create_table "formats", :force => true do |t|
    t.float   "margins"
    t.float   "bar_height"
    t.float   "bar_vspace"
    t.float   "track_vspace"
    t.float   "scale_arrow_width"
    t.float   "scale_arrow_height"
    t.float   "arrow_width"
    t.float   "stroke_width"
    t.float   "stroke_marked_width"
    t.boolean "show_grid"
    t.float   "min_len_block"
    t.float   "track_title_color_red"
    t.float   "track_title_color_green"
    t.float   "track_title_color_blue"
    t.float   "default_stroke_color_red"
    t.float   "default_stroke_color_green"
    t.float   "default_stroke_color_blue"
    t.integer "configuration_id"
  end

  create_table "sequence_regions", :force => true do |t|
    t.string  "seq_id",        :default => "", :null => false
    t.integer "annotation_id", :default => 0,  :null => false
    t.integer "seq_begin",     :default => 0,  :null => false
    t.integer "seq_end",       :default => 0,  :null => false
    t.text    "description"
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

  create_table "uuid_logs", :force => true do |t|
    t.string   "uuid",       :limit => 36
    t.text     "args"
    t.datetime "created_at"
  end

  add_index "uuid_logs", ["uuid"], :name => "index_uuid_logs_on_uuid"
  add_index "uuid_logs", ["created_at"], :name => "index_uuid_logs_on_created_at"

end
