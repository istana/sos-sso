class CreateUsers < ActiveRecord::Migration
	def up
		create_table :users do |t|
			t.string :username, null: false
			t.integer :gid, null: false, limit: 8
			t.string :gecos, null: false, default: ''
			t.string :homedir, null: false
			t.string :shell, null: false, default: '/usr/bin/rssh'
			# shadow
			t.string :password, null: false, default: 'x'
			# limit => 8 (8 bytes)
			t.integer :lstchg, null: false, default: 1, limit: 8
			t.integer :min, null: false, default: 0, limit: 8
			t.integer :max, null: false, default: 9999, limit: 8
			t.integer :warn, null: false,  default: 30, limit: 8
			t.integer :inact, null: false, default: 0, limit: 8
			# Number of days since 1970-01-01 until account expires.
			t.integer :expire, null: false, default: -1, limit: 8
			t.integer :flag, null: false, default: 0, limit: 1

			# 50 MiB
			t.integer :quota_mass, null: false, default: 52428800, limit: 8
			t.integer :quota_inodes, null: false, default: 15000, limit: 5

			t.boolean :active, null: false, default: true
			t.timestamps
		end
		execute "ALTER TABLE users ADD CONSTRAINT unqusername UNIQUE(username);"
		execute "ALTER TABLE users AUTO_INCREMENT=8000;"
		add_index :users, :active
	end

	def down
		drop_table :users
	end
end
