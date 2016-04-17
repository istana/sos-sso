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

ActiveRecord::Schema.define(version: 20150427220148) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "aliases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "active",     default: true, null: false
    t.string   "name",                      null: false
    t.integer  "user_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliases", ["active"], name: "index_aliases_on_active", using: :btree

  create_table "cui", primary_key: ["username", "clientipaddress", "callingstationid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "clientipaddress",  default: "",                         null: false
    t.string   "callingstationid", default: "",                         null: false
    t.string   "username",         default: "",                         null: false
    t.string   "cui",              default: "",                         null: false
    t.datetime "creationdate",     default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "lastaccounting",                                        null: false
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                     null: false
    t.string   "password",   default: "x", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name"], name: "unqname", unique: true, using: :btree

  create_table "groups_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", using: :btree

  create_table "nas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "nasname",                               null: false
    t.string  "shortname"
    t.string  "xtype",       default: "other"
    t.integer "ports"
    t.string  "secret",      default: "secret",        null: false
    t.string  "server"
    t.string  "community"
    t.string  "description", default: "RADIUS Client"
  end

  add_index "nas", ["nasname"], name: "nasname", using: :btree

  create_table "radacct", primary_key: "radacctid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "acctsessionid",                  default: "", null: false
    t.string   "acctuniqueid",                   default: "", null: false
    t.string   "username",                       default: "", null: false
    t.string   "groupname",                      default: "", null: false
    t.string   "realm",                          default: ""
    t.string   "nasipaddress",                   default: "", null: false
    t.string   "nasportid"
    t.string   "nasporttype"
    t.datetime "acctstarttime"
    t.datetime "acctstoptime"
    t.integer  "acctsessiontime",      limit: 8
    t.string   "acctauthentic"
    t.string   "connectioninfo_start"
    t.string   "connectioninfo_stop"
    t.integer  "acctinputoctets",      limit: 8
    t.integer  "acctoutputoctets",     limit: 8
    t.string   "calledstationid",                default: "", null: false
    t.string   "callingstationid",               default: "", null: false
    t.string   "acctterminatecause",             default: "", null: false
    t.string   "servicetype"
    t.string   "framedprotocol"
    t.string   "framedipaddress",                default: "", null: false
    t.integer  "acctstartdelay",       limit: 8
    t.integer  "acctstopdelay",        limit: 8
    t.string   "xascendsessionsvrkey"
  end

  add_index "radacct", ["acctsessionid"], name: "acctsessionid", using: :btree
  add_index "radacct", ["acctsessiontime"], name: "acctsessiontime", using: :btree
  add_index "radacct", ["acctstarttime"], name: "acctstarttime", using: :btree
  add_index "radacct", ["acctstoptime"], name: "acctstoptime", using: :btree
  add_index "radacct", ["acctuniqueid"], name: "acctuniqueid", unique: true, using: :btree
  add_index "radacct", ["framedipaddress"], name: "framedipaddress", using: :btree
  add_index "radacct", ["nasipaddress"], name: "nasipaddress", using: :btree
  add_index "radacct", ["username"], name: "username", using: :btree

  create_table "radcheck", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username",           default: "",   null: false
    t.string "attr",               default: "",   null: false
    t.string "op",       limit: 2, default: "==", null: false
    t.string "value",              default: "",   null: false
  end

  add_index "radcheck", ["username"], name: "username", length: {"username"=>32}, using: :btree

  create_table "radgroupcheck", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "groupname",           default: "",   null: false
    t.string "attr",                default: "",   null: false
    t.string "op",        limit: 2, default: "==", null: false
    t.string "value",               default: "",   null: false
  end

  add_index "radgroupcheck", ["groupname"], name: "groupname", length: {"groupname"=>32}, using: :btree

  create_table "radgroupreply", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "groupname",           default: "",   null: false
    t.string "attr",                default: "",   null: false
    t.string "op",        limit: 2, default: "==", null: false
    t.string "value",               default: "",   null: false
  end

  add_index "radgroupreply", ["groupname"], name: "groupname", length: {"groupname"=>32}, using: :btree

  create_table "radippool", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "pool_name",                     null: false
    t.string   "framedipaddress",  default: "", null: false
    t.string   "nasipaddress",     default: "", null: false
    t.string   "calledstationid",               null: false
    t.string   "callingstationid",              null: false
    t.datetime "expiry_time"
    t.string   "username",         default: "", null: false
    t.string   "pool_key",                      null: false
  end

  add_index "radippool", ["framedipaddress"], name: "framedipaddress", using: :btree
  add_index "radippool", ["nasipaddress", "pool_key", "framedipaddress"], name: "radippool_nasip_poolkey_ipaddress", using: :btree
  add_index "radippool", ["pool_name", "expiry_time"], name: "radippool_poolname_expire", using: :btree

  create_table "radpostauth", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username", default: "", null: false
    t.string   "pass",     default: "", null: false
    t.string   "reply",    default: "", null: false
    t.datetime "authdate",              null: false
  end

  create_table "radreply", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username",           default: "",   null: false
    t.string "attr",               default: "",   null: false
    t.string "op",       limit: 2, default: "==", null: false
    t.string "value",              default: "",   null: false
  end

  add_index "radreply", ["username"], name: "username", length: {"username"=>32}, using: :btree

  create_table "radusergroup", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "username",  default: "", null: false
    t.string  "groupname", default: "", null: false
    t.integer "priority",  default: 1,  null: false
  end

  add_index "radusergroup", ["username"], name: "username", length: {"username"=>32}, using: :btree

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",                                          null: false
    t.integer  "gid",           limit: 8,                           null: false
    t.string   "gecos",                   default: "",              null: false
    t.string   "homedir",                                           null: false
    t.string   "shell",                   default: "/usr/bin/rssh", null: false
    t.string   "password",                default: "x",             null: false
    t.integer  "lstchg",        limit: 8, default: 1,               null: false
    t.integer  "min",           limit: 8, default: 0,               null: false
    t.integer  "max",           limit: 8, default: 9999,            null: false
    t.integer  "warn",          limit: 8, default: 30,              null: false
    t.integer  "inact",         limit: 8, default: 0,               null: false
    t.integer  "expire",        limit: 8, default: -1,              null: false
    t.integer  "flag",          limit: 1, default: 0,               null: false
    t.integer  "quota_mass",    limit: 8, default: 52428800,        null: false
    t.integer  "quota_inodes",  limit: 8, default: 15000,           null: false
    t.boolean  "active",                  default: true,            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ntlm_password"
  end

  add_index "users", ["active"], name: "index_users_on_active", using: :btree
  add_index "users", ["username"], name: "unqusername", unique: true, using: :btree

  create_table "version_associations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "item_type",                    null: false
    t.integer  "item_id",                      null: false
    t.string   "event",                        null: false
    t.string   "whodunnit"
    t.text     "object",         limit: 65535
    t.datetime "created_at"
    t.text     "object_changes", limit: 65535
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  create_table "wimax", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",           default: "", null: false
    t.datetime "authdate",                        null: false
    t.string   "spi",                default: "", null: false
    t.string   "mipkey",             default: "", null: false
    t.integer  "lifetime", limit: 8
  end

  add_index "wimax", ["spi"], name: "spi", using: :btree
  add_index "wimax", ["username"], name: "username", using: :btree

end
