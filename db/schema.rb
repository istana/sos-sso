# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_20_145141) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "aliases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["active"], name: "index_aliases_on_active"
  end

  create_table "cui", primary_key: ["username", "clientipaddress", "callingstationid"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "clientipaddress", default: "", null: false
    t.string "callingstationid", default: "", null: false
    t.string "username", default: "", null: false
    t.string "cui", default: "", null: false
    t.datetime "creationdate", default: -> { "current_timestamp()" }, null: false
    t.datetime "lastaccounting", null: false
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "password", default: "x", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "unqname", unique: true
  end

  create_table "groups_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"
  end

  create_table "nas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nasname", null: false
    t.string "shortname"
    t.string "xtype", default: "other"
    t.integer "ports"
    t.string "secret", default: "secret", null: false
    t.string "server"
    t.string "community"
    t.string "description", default: "RADIUS Client"
    t.index ["nasname"], name: "nasname"
  end

  create_table "radacct", primary_key: "radacctid", id: :bigint, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "acctsessionid", default: "", null: false
    t.string "acctuniqueid", default: "", null: false
    t.string "username", default: "", null: false
    t.string "groupname", default: "", null: false
    t.string "realm", default: ""
    t.string "nasipaddress", default: "", null: false
    t.string "nasportid"
    t.string "nasporttype"
    t.datetime "acctstarttime"
    t.datetime "acctstoptime"
    t.bigint "acctsessiontime"
    t.string "acctauthentic"
    t.string "connectioninfo_start"
    t.string "connectioninfo_stop"
    t.bigint "acctinputoctets"
    t.bigint "acctoutputoctets"
    t.string "calledstationid", default: "", null: false
    t.string "callingstationid", default: "", null: false
    t.string "acctterminatecause", default: "", null: false
    t.string "servicetype"
    t.string "framedprotocol"
    t.string "framedipaddress", default: "", null: false
    t.bigint "acctstartdelay"
    t.bigint "acctstopdelay"
    t.string "xascendsessionsvrkey"
    t.index ["acctsessionid"], name: "acctsessionid"
    t.index ["acctsessiontime"], name: "acctsessiontime"
    t.index ["acctstarttime"], name: "acctstarttime"
    t.index ["acctstoptime"], name: "acctstoptime"
    t.index ["acctuniqueid"], name: "acctuniqueid", unique: true
    t.index ["framedipaddress"], name: "framedipaddress"
    t.index ["nasipaddress"], name: "nasipaddress"
    t.index ["username"], name: "username"
  end

  create_table "radcheck", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "attr", default: "", null: false
    t.string "op", limit: 2, default: "==", null: false
    t.string "value", default: "", null: false
    t.index ["username"], name: "username", length: 32
  end

  create_table "radgroupcheck", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "groupname", default: "", null: false
    t.string "attr", default: "", null: false
    t.string "op", limit: 2, default: "==", null: false
    t.string "value", default: "", null: false
    t.index ["groupname"], name: "groupname", length: 32
  end

  create_table "radgroupreply", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "groupname", default: "", null: false
    t.string "attr", default: "", null: false
    t.string "op", limit: 2, default: "==", null: false
    t.string "value", default: "", null: false
    t.index ["groupname"], name: "groupname", length: 32
  end

  create_table "radippool", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "pool_name", null: false
    t.string "framedipaddress", default: "", null: false
    t.string "nasipaddress", default: "", null: false
    t.string "calledstationid", null: false
    t.string "callingstationid", null: false
    t.datetime "expiry_time"
    t.string "username", default: "", null: false
    t.string "pool_key", null: false
    t.index ["framedipaddress"], name: "framedipaddress"
    t.index ["nasipaddress", "pool_key", "framedipaddress"], name: "radippool_nasip_poolkey_ipaddress"
    t.index ["pool_name", "expiry_time"], name: "radippool_poolname_expire"
  end

  create_table "radpostauth", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "pass", default: "", null: false
    t.string "reply", default: "", null: false
    t.datetime "authdate", null: false
  end

  create_table "radreply", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "attr", default: "", null: false
    t.string "op", limit: 2, default: "==", null: false
    t.string "value", default: "", null: false
    t.index ["username"], name: "username", length: 32
  end

  create_table "radusergroup", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "groupname", default: "", null: false
    t.integer "priority", default: 1, null: false
    t.index ["username"], name: "username", length: 32
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", null: false
    t.bigint "gid", null: false
    t.string "gecos", default: "", null: false
    t.string "homedir", null: false
    t.string "shell", default: "/usr/bin/rssh", null: false
    t.string "password", default: "x", null: false
    t.bigint "lstchg", default: 1, null: false
    t.bigint "min", default: 0, null: false
    t.bigint "max", default: 9999, null: false
    t.bigint "warn", default: 30, null: false
    t.bigint "inact", default: 0, null: false
    t.bigint "expire", default: -1, null: false
    t.integer "flag", limit: 1, default: 0, null: false
    t.bigint "quota_mass", default: 52428800, null: false
    t.bigint "quota_inodes", default: 15000, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "ntlm_password"
    t.index ["active"], name: "index_users_on_active"
    t.index ["username"], name: "unqusername", unique: true
  end

  create_table "version_associations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  create_table "wimax", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.datetime "authdate", null: false
    t.string "spi", default: "", null: false
    t.string "mipkey", default: "", null: false
    t.bigint "lifetime"
    t.index ["spi"], name: "spi"
    t.index ["username"], name: "username"
  end

end
