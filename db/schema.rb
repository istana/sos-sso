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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140831193453) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",               limit: 255, default: "", null: false
    t.string   "encrypted_password",  limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "aliases", force: :cascade do |t|
    t.boolean  "active",     limit: 1,   default: true, null: false
    t.string   "name",       limit: 255,                null: false
    t.integer  "user_id",    limit: 4,                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliases", ["active"], name: "index_aliases_on_active", using: :btree

  create_table "cui", id: false, force: :cascade do |t|
    t.string   "clientipaddress",  limit: 255, default: "", null: false
    t.string   "callingstationid", limit: 255, default: "", null: false
    t.string   "username",         limit: 255, default: "", null: false
    t.string   "cui",              limit: 255, default: "", null: false
    t.datetime "creationdate",                              null: false
    t.datetime "lastaccounting",                            null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255,               null: false
    t.string   "password",   limit: 255, default: "x", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name"], name: "unqname", unique: true, using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4, null: false
    t.integer "user_id",  limit: 4, null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", using: :btree

  create_table "nas", force: :cascade do |t|
    t.string  "nasname",     limit: 255,                           null: false
    t.string  "shortname",   limit: 255
    t.string  "xtype",       limit: 255, default: "other"
    t.integer "ports",       limit: 4
    t.string  "secret",      limit: 255, default: "secret",        null: false
    t.string  "server",      limit: 255
    t.string  "community",   limit: 255
    t.string  "description", limit: 255, default: "RADIUS Client"
  end

  add_index "nas", ["nasname"], name: "nasname", using: :btree

  create_table "radacct", primary_key: "radacctid", force: :cascade do |t|
    t.string   "acctsessionid",        limit: 255, default: "", null: false
    t.string   "acctuniqueid",         limit: 255, default: "", null: false
    t.string   "username",             limit: 255, default: "", null: false
    t.string   "groupname",            limit: 255, default: "", null: false
    t.string   "realm",                limit: 255, default: ""
    t.string   "nasipaddress",         limit: 255, default: "", null: false
    t.string   "nasportid",            limit: 255
    t.string   "nasporttype",          limit: 255
    t.datetime "acctstarttime"
    t.datetime "acctstoptime"
    t.integer  "acctsessiontime",      limit: 8
    t.string   "acctauthentic",        limit: 255
    t.string   "connectioninfo_start", limit: 255
    t.string   "connectioninfo_stop",  limit: 255
    t.integer  "acctinputoctets",      limit: 8
    t.integer  "acctoutputoctets",     limit: 8
    t.string   "calledstationid",      limit: 255, default: "", null: false
    t.string   "callingstationid",     limit: 255, default: "", null: false
    t.string   "acctterminatecause",   limit: 255, default: "", null: false
    t.string   "servicetype",          limit: 255
    t.string   "framedprotocol",       limit: 255
    t.string   "framedipaddress",      limit: 255, default: "", null: false
    t.integer  "acctstartdelay",       limit: 8
    t.integer  "acctstopdelay",        limit: 8
    t.string   "xascendsessionsvrkey", limit: 255
  end

  add_index "radacct", ["acctsessionid"], name: "acctsessionid", using: :btree
  add_index "radacct", ["acctsessiontime"], name: "acctsessiontime", using: :btree
  add_index "radacct", ["acctstarttime"], name: "acctstarttime", using: :btree
  add_index "radacct", ["acctstoptime"], name: "acctstoptime", using: :btree
  add_index "radacct", ["acctuniqueid"], name: "acctuniqueid", unique: true, using: :btree
  add_index "radacct", ["framedipaddress"], name: "framedipaddress", using: :btree
  add_index "radacct", ["nasipaddress"], name: "nasipaddress", using: :btree
  add_index "radacct", ["username"], name: "username", using: :btree

  create_table "radcheck", force: :cascade do |t|
    t.string "username", limit: 255, default: "",   null: false
    t.string "attr",     limit: 255, default: "",   null: false
    t.string "op",       limit: 2,   default: "==", null: false
    t.string "value",    limit: 255, default: "",   null: false
  end

  add_index "radcheck", ["username"], name: "username", length: {"username"=>32}, using: :btree

  create_table "radgroupcheck", force: :cascade do |t|
    t.string "groupname", limit: 255, default: "",   null: false
    t.string "attr",      limit: 255, default: "",   null: false
    t.string "op",        limit: 2,   default: "==", null: false
    t.string "value",     limit: 255, default: "",   null: false
  end

  add_index "radgroupcheck", ["groupname"], name: "groupname", length: {"groupname"=>32}, using: :btree

  create_table "radgroupreply", force: :cascade do |t|
    t.string "groupname", limit: 255, default: "",   null: false
    t.string "attr",      limit: 255, default: "",   null: false
    t.string "op",        limit: 2,   default: "==", null: false
    t.string "value",     limit: 255, default: "",   null: false
  end

  add_index "radgroupreply", ["groupname"], name: "groupname", length: {"groupname"=>32}, using: :btree

  create_table "radippool", force: :cascade do |t|
    t.string   "pool_name",        limit: 255,              null: false
    t.string   "framedipaddress",  limit: 255, default: "", null: false
    t.string   "nasipaddress",     limit: 255, default: "", null: false
    t.string   "calledstationid",  limit: 255,              null: false
    t.string   "callingstationid", limit: 255,              null: false
    t.datetime "expiry_time"
    t.string   "username",         limit: 255, default: "", null: false
    t.string   "pool_key",         limit: 255,              null: false
  end

  add_index "radippool", ["framedipaddress"], name: "framedipaddress", using: :btree
  add_index "radippool", ["nasipaddress", "pool_key", "framedipaddress"], name: "radippool_nasip_poolkey_ipaddress", using: :btree
  add_index "radippool", ["pool_name", "expiry_time"], name: "radippool_poolname_expire", using: :btree

  create_table "radpostauth", force: :cascade do |t|
    t.string   "username", limit: 255, default: "", null: false
    t.string   "pass",     limit: 255, default: "", null: false
    t.string   "reply",    limit: 255, default: "", null: false
    t.datetime "authdate",                          null: false
  end

  create_table "radreply", force: :cascade do |t|
    t.string "username", limit: 255, default: "",   null: false
    t.string "attr",     limit: 255, default: "",   null: false
    t.string "op",       limit: 2,   default: "==", null: false
    t.string "value",    limit: 255, default: "",   null: false
  end

  add_index "radreply", ["username"], name: "username", length: {"username"=>32}, using: :btree

  create_table "radusergroup", id: false, force: :cascade do |t|
    t.string  "username",  limit: 255, default: "", null: false
    t.string  "groupname", limit: 255, default: "", null: false
    t.integer "priority",  limit: 4,   default: 1,  null: false
  end

  add_index "radusergroup", ["username"], name: "username", length: {"username"=>32}, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",      limit: 255,                           null: false
    t.integer  "gid",           limit: 8,                             null: false
    t.string   "gecos",         limit: 255, default: "",              null: false
    t.string   "homedir",       limit: 255,                           null: false
    t.string   "shell",         limit: 255, default: "/usr/bin/rssh", null: false
    t.string   "password",      limit: 255, default: "x",             null: false
    t.integer  "lstchg",        limit: 8,   default: 1,               null: false
    t.integer  "min",           limit: 8,   default: 0,               null: false
    t.integer  "max",           limit: 8,   default: 9999,            null: false
    t.integer  "warn",          limit: 8,   default: 30,              null: false
    t.integer  "inact",         limit: 8,   default: 0,               null: false
    t.integer  "expire",        limit: 8,   default: -1,              null: false
    t.integer  "flag",          limit: 1,   default: 0,               null: false
    t.integer  "quota_mass",    limit: 8,   default: 52428800,        null: false
    t.integer  "quota_inodes",  limit: 8,   default: 15000,           null: false
    t.boolean  "active",        limit: 1,   default: true,            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ntlm_password", limit: 255
  end

  add_index "users", ["active"], name: "index_users_on_active", using: :btree
  add_index "users", ["username"], name: "unqusername", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,   null: false
    t.integer  "item_id",        limit: 4,     null: false
    t.string   "event",          limit: 255,   null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 65535
    t.datetime "created_at"
    t.text     "object_changes", limit: 65535
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "wimax", force: :cascade do |t|
    t.string   "username", limit: 255, default: "", null: false
    t.datetime "authdate",                          null: false
    t.string   "spi",      limit: 255, default: "", null: false
    t.string   "mipkey",   limit: 255, default: "", null: false
    t.integer  "lifetime", limit: 8
  end

  add_index "wimax", ["spi"], name: "spi", using: :btree
  add_index "wimax", ["username"], name: "username", using: :btree

end
