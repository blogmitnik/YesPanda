# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20190122024132) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "platform"
    t.boolean  "enabled",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"
  add_index "devices", ["uuid"], :name => "index_devices_on_uuid"

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "uid",                          :null => false
    t.string   "secret",                       :null => false
    t.string   "redirect_uri",                 :null => false
    t.string   "scopes",       :default => "", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "published_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "deleted_at"
    t.integer  "product_id"
    t.integer  "current_year"
    t.integer  "current_month"
    t.integer  "current_mday"
    t.integer  "current_hour"
    t.integer  "current_year_main"
    t.integer  "current_month_main"
    t.integer  "current_mday_main"
    t.integer  "current_hour_main"
    t.integer  "current_year_mini"
    t.integer  "current_month_mini"
    t.integer  "current_mday_mini"
    t.integer  "current_hour_mini"
  end

  add_index "posts", ["current_hour"], :name => "index_posts_on_current_hour"
  add_index "posts", ["current_hour_main"], :name => "index_posts_on_current_hour_main"
  add_index "posts", ["current_hour_mini"], :name => "index_posts_on_current_hour_mini"
  add_index "posts", ["current_mday"], :name => "index_posts_on_current_mday"
  add_index "posts", ["current_mday_main"], :name => "index_posts_on_current_mday_main"
  add_index "posts", ["current_mday_mini"], :name => "index_posts_on_current_mday_mini"
  add_index "posts", ["current_month"], :name => "index_posts_on_current_month"
  add_index "posts", ["current_month_main"], :name => "index_posts_on_current_month_main"
  add_index "posts", ["current_month_mini"], :name => "index_posts_on_current_month_mini"
  add_index "posts", ["current_year"], :name => "index_posts_on_current_year"
  add_index "posts", ["current_year_main"], :name => "index_posts_on_current_year_main"
  add_index "posts", ["current_year_mini"], :name => "index_posts_on_current_year_mini"
  add_index "posts", ["deleted_at"], :name => "index_posts_on_deleted_at"
  add_index "posts", ["product_id"], :name => "index_posts_on_product_id"
  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"
  add_index "posts", ["title"], :name => "index_posts_on_title"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "products", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "products", ["title"], :name => "index_products_on_title"
  add_index "products", ["user_id"], :name => "index_products_on_user_id"

  create_table "report_mains", :force => true do |t|
    t.integer  "post_id",             :null => false
    t.integer  "yield_file_id",       :null => false
    t.integer  "station_id",          :null => false
    t.string   "model",               :null => false
    t.string   "stage",               :null => false
    t.integer  "seqno",               :null => false
    t.string   "config",              :null => false
    t.string   "station_name",        :null => false
    t.integer  "input",               :null => false
    t.integer  "first_pass",          :null => false
    t.integer  "retest_pass",         :null => false
    t.integer  "fail",                :null => false
    t.integer  "retest_process",      :null => false
    t.integer  "test_waive",          :null => false
    t.integer  "design_waive",        :null => false
    t.integer  "cof_waive",           :null => false
    t.integer  "rd_area",             :null => false
    t.integer  "bpl",                 :null => false
    t.integer  "ntf",                 :null => false
    t.integer  "failure_waive",       :null => false
    t.integer  "repaire_ok",          :null => false
    t.integer  "inl_repaire",         :null => false
    t.integer  "dip",                 :null => false
    t.integer  "defect",              :null => false
    t.integer  "fail_borrow",         :null => false
    t.integer  "pass_borrow",         :null => false
    t.string   "yield_type",          :null => false
    t.float    "yield_rate"
    t.float    "yield_rate_today"
    t.float    "fp_yield_rate"
    t.datetime "published_at",        :null => false
    t.integer  "p_year",              :null => false
    t.integer  "p_month",             :null => false
    t.integer  "p_mday",              :null => false
    t.integer  "p_hour",              :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.float    "fp_yield_rate_today"
    t.integer  "input_today"
    t.integer  "output_today"
  end

  add_index "report_mains", ["config", "fp_yield_rate", "published_at"], :name => "super_index_15"
  add_index "report_mains", ["config", "fp_yield_rate_today", "published_at"], :name => "super_index_16"
  add_index "report_mains", ["config", "yield_rate", "published_at"], :name => "super_index_13"
  add_index "report_mains", ["config", "yield_rate_today", "published_at"], :name => "super_index_14"
  add_index "report_mains", ["fp_yield_rate"], :name => "index_report_mains_on_fp_yield_rate"
  add_index "report_mains", ["fp_yield_rate_today"], :name => "index_report_mains_on_fp_yield_rate_today"
  add_index "report_mains", ["input_today"], :name => "index_report_mains_on_input_today"
  add_index "report_mains", ["model"], :name => "index_report_mains_on_model"
  add_index "report_mains", ["output_today"], :name => "index_report_mains_on_output_today"
  add_index "report_mains", ["p_year", "p_month", "p_mday", "p_hour"], :name => "index_report_mains_on_p_year_and_p_month_and_p_mday_and_p_hour"
  add_index "report_mains", ["p_year", "p_month", "p_mday"], :name => "index_report_mains_on_p_year_and_p_month_and_p_mday"
  add_index "report_mains", ["post_id", "station_name", "config", "p_year", "p_month", "p_mday", "p_hour"], :name => "super_index_12"
  add_index "report_mains", ["post_id"], :name => "index_report_mains_on_post_id"
  add_index "report_mains", ["published_at"], :name => "index_report_mains_on_published_at"
  add_index "report_mains", ["seqno", "stage", "config", "published_at"], :name => "super_index_11"
  add_index "report_mains", ["seqno"], :name => "index_report_mains_on_seqno"
  add_index "report_mains", ["stage", "config", "published_at"], :name => "super_index_10"
  add_index "report_mains", ["stage", "p_year", "p_month", "p_mday", "p_hour"], :name => "super_index_9"
  add_index "report_mains", ["stage"], :name => "index_report_mains_on_stage"
  add_index "report_mains", ["station_id", "p_hour"], :name => "index_report_mains_on_station_id_and_p_hour"
  add_index "report_mains", ["station_id", "published_at"], :name => "index_report_mains_on_station_id_and_published_at"
  add_index "report_mains", ["station_id"], :name => "index_report_mains_on_station_id"
  add_index "report_mains", ["station_name"], :name => "index_report_mains_on_station_name"
  add_index "report_mains", ["yield_file_id"], :name => "index_report_mains_on_yield_file_id"
  add_index "report_mains", ["yield_rate"], :name => "index_report_mains_on_yield_rate"
  add_index "report_mains", ["yield_rate_today"], :name => "index_report_mains_on_yield_rate_today"

  create_table "report_minis", :force => true do |t|
    t.integer  "post_id",             :null => false
    t.integer  "yield_file_id",       :null => false
    t.integer  "station_id",          :null => false
    t.string   "model",               :null => false
    t.string   "stage",               :null => false
    t.integer  "seqno",               :null => false
    t.string   "config",              :null => false
    t.string   "station_name",        :null => false
    t.integer  "input",               :null => false
    t.integer  "first_pass",          :null => false
    t.integer  "retest_pass",         :null => false
    t.integer  "fail",                :null => false
    t.integer  "retest_process",      :null => false
    t.integer  "test_waive",          :null => false
    t.integer  "design_waive",        :null => false
    t.integer  "cof_waive",           :null => false
    t.integer  "rd_area",             :null => false
    t.integer  "bpl",                 :null => false
    t.integer  "ntf",                 :null => false
    t.integer  "failure_waive",       :null => false
    t.integer  "repaire_ok",          :null => false
    t.integer  "inl_repaire",         :null => false
    t.integer  "dip",                 :null => false
    t.integer  "defect",              :null => false
    t.integer  "fail_borrow",         :null => false
    t.integer  "pass_borrow",         :null => false
    t.string   "yield_type",          :null => false
    t.float    "yield_rate"
    t.float    "yield_rate_today"
    t.float    "fp_yield_rate"
    t.datetime "published_at",        :null => false
    t.integer  "p_year",              :null => false
    t.integer  "p_month",             :null => false
    t.integer  "p_mday",              :null => false
    t.integer  "p_hour",              :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.float    "fp_yield_rate_today"
    t.integer  "input_today"
    t.integer  "output_today"
  end

  add_index "report_minis", ["config", "fp_yield_rate", "published_at"], :name => "super_index_23"
  add_index "report_minis", ["config", "fp_yield_rate_today", "published_at"], :name => "super_index_24"
  add_index "report_minis", ["config", "yield_rate", "published_at"], :name => "super_index_21"
  add_index "report_minis", ["config", "yield_rate_today", "published_at"], :name => "super_index_22"
  add_index "report_minis", ["fp_yield_rate"], :name => "index_report_minis_on_fp_yield_rate"
  add_index "report_minis", ["fp_yield_rate_today"], :name => "index_report_minis_on_fp_yield_rate_today"
  add_index "report_minis", ["input_today"], :name => "index_report_minis_on_input_today"
  add_index "report_minis", ["model"], :name => "index_report_minis_on_model"
  add_index "report_minis", ["output_today"], :name => "index_report_minis_on_output_today"
  add_index "report_minis", ["p_year", "p_month", "p_mday", "p_hour"], :name => "index_report_minis_on_p_year_and_p_month_and_p_mday_and_p_hour"
  add_index "report_minis", ["p_year", "p_month", "p_mday"], :name => "index_report_minis_on_p_year_and_p_month_and_p_mday"
  add_index "report_minis", ["post_id", "station_name", "config", "p_year", "p_month", "p_mday", "p_hour"], :name => "super_index_20"
  add_index "report_minis", ["post_id"], :name => "index_report_minis_on_post_id"
  add_index "report_minis", ["published_at"], :name => "index_report_minis_on_published_at"
  add_index "report_minis", ["seqno", "stage", "config", "published_at"], :name => "super_index_19"
  add_index "report_minis", ["seqno"], :name => "index_report_minis_on_seqno"
  add_index "report_minis", ["stage", "config", "published_at"], :name => "super_index_18"
  add_index "report_minis", ["stage", "p_year", "p_month", "p_mday", "p_hour"], :name => "super_index_17"
  add_index "report_minis", ["stage"], :name => "index_report_minis_on_stage"
  add_index "report_minis", ["station_id", "p_hour"], :name => "index_report_minis_on_station_id_and_p_hour"
  add_index "report_minis", ["station_id", "published_at"], :name => "index_report_minis_on_station_id_and_published_at"
  add_index "report_minis", ["station_id"], :name => "index_report_minis_on_station_id"
  add_index "report_minis", ["station_name"], :name => "index_report_minis_on_station_name"
  add_index "report_minis", ["yield_file_id"], :name => "index_report_minis_on_yield_file_id"
  add_index "report_minis", ["yield_rate"], :name => "index_report_minis_on_yield_rate"
  add_index "report_minis", ["yield_rate_today"], :name => "index_report_minis_on_yield_rate_today"

  create_table "reports", :force => true do |t|
    t.integer  "post_id",             :null => false
    t.integer  "yield_file_id",       :null => false
    t.integer  "station_id",          :null => false
    t.string   "model",               :null => false
    t.string   "stage",               :null => false
    t.integer  "seqno",               :null => false
    t.string   "config",              :null => false
    t.string   "station_name",        :null => false
    t.integer  "input",               :null => false
    t.integer  "first_pass",          :null => false
    t.integer  "retest_pass",         :null => false
    t.integer  "fail",                :null => false
    t.integer  "retest_process",      :null => false
    t.integer  "test_waive",          :null => false
    t.integer  "design_waive",        :null => false
    t.integer  "cof_waive",           :null => false
    t.integer  "rd_area",             :null => false
    t.integer  "bpl",                 :null => false
    t.integer  "ntf",                 :null => false
    t.integer  "failure_waive",       :null => false
    t.integer  "repaire_ok",          :null => false
    t.integer  "inl_repaire",         :null => false
    t.integer  "dip",                 :null => false
    t.integer  "defect",              :null => false
    t.integer  "fail_borrow",         :null => false
    t.integer  "pass_borrow",         :null => false
    t.string   "yield_type",          :null => false
    t.float    "yield_rate"
    t.float    "yield_rate_today"
    t.float    "fp_yield_rate"
    t.datetime "published_at",        :null => false
    t.integer  "p_year",              :null => false
    t.integer  "p_month",             :null => false
    t.integer  "p_mday",              :null => false
    t.integer  "p_hour",              :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.float    "fp_yield_rate_today"
    t.integer  "input_today"
    t.integer  "output_today"
  end

  add_index "reports", ["config", "fp_yield_rate", "published_at"], :name => "super_index_7"
  add_index "reports", ["config", "fp_yield_rate_today", "published_at"], :name => "super_index_8"
  add_index "reports", ["config", "yield_rate", "published_at"], :name => "super_index_5"
  add_index "reports", ["config", "yield_rate_today", "published_at"], :name => "super_index_6"
  add_index "reports", ["fp_yield_rate"], :name => "index_reports_on_fp_yield_rate"
  add_index "reports", ["fp_yield_rate_today"], :name => "index_reports_on_fp_yield_rate_today"
  add_index "reports", ["input_today"], :name => "index_reports_on_input_today"
  add_index "reports", ["model"], :name => "index_reports_on_model"
  add_index "reports", ["output_today"], :name => "index_reports_on_output_today"
  add_index "reports", ["p_year", "p_month", "p_mday", "p_hour"], :name => "index_reports_on_p_year_and_p_month_and_p_mday_and_p_hour"
  add_index "reports", ["p_year", "p_month", "p_mday"], :name => "index_reports_on_p_year_and_p_month_and_p_mday"
  add_index "reports", ["post_id", "station_name", "config", "p_year", "p_month", "p_mday", "p_hour"], :name => "super_index_4"
  add_index "reports", ["post_id"], :name => "index_reports_on_post_id"
  add_index "reports", ["published_at"], :name => "index_reports_on_published_at"
  add_index "reports", ["seqno", "stage", "config", "published_at"], :name => "my_index_3"
  add_index "reports", ["seqno", "stage", "config", "published_at"], :name => "super_index_3"
  add_index "reports", ["seqno"], :name => "index_reports_on_seqno"
  add_index "reports", ["stage", "config", "published_at"], :name => "my_index_2"
  add_index "reports", ["stage", "config", "published_at"], :name => "super_index_2"
  add_index "reports", ["stage", "p_year", "p_month", "p_mday", "p_hour"], :name => "my_index"
  add_index "reports", ["stage", "p_year", "p_month", "p_mday", "p_hour"], :name => "my_index_1"
  add_index "reports", ["stage", "p_year", "p_month", "p_mday", "p_hour"], :name => "super_index_1"
  add_index "reports", ["stage"], :name => "index_reports_on_stage"
  add_index "reports", ["station_id", "p_hour"], :name => "index_reports_on_station_id_and_p_hour"
  add_index "reports", ["station_id", "published_at"], :name => "index_reports_on_station_id_and_published_at"
  add_index "reports", ["station_id"], :name => "index_reports_on_station_id"
  add_index "reports", ["station_name"], :name => "index_reports_on_station_name"
  add_index "reports", ["yield_file_id"], :name => "index_reports_on_yield_file_id"
  add_index "reports", ["yield_rate"], :name => "index_reports_on_yield_rate"
  add_index "reports", ["yield_rate_today"], :name => "index_reports_on_yield_rate_today"

  create_table "stations", :force => true do |t|
    t.integer  "post_id",       :null => false
    t.integer  "yield_file_id", :null => false
    t.string   "name",          :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "stations", ["name"], :name => "index_stations_on_name"
  add_index "stations", ["yield_file_id"], :name => "index_stations_on_yield_file_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_token"
    t.datetime "facebook_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_expires_at"], :name => "index_users_on_facebook_expires_at"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"
  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "yield_files", :force => true do |t|
    t.integer  "post_id",      :null => false
    t.string   "file_name",    :null => false
    t.integer  "total_row",    :null => false
    t.datetime "published_at", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "yield_files", ["file_name"], :name => "index_yield_files_on_file_name", :unique => true
  add_index "yield_files", ["post_id"], :name => "index_yield_files_on_post_id"

end
