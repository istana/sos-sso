class FreeradiusIppool < ActiveRecord::Migration
  def change
		create_table(:radippool) do |t|
			t.string :pool_name, null: false
			t.string :framedipaddress, null: false, default: ''
			t.string :nasipaddress, null: false, default: ''
			t.string :calledstationid, null: false
			t.string :callingstationid, null: false
			t.datetime :expiry_time, default: nil
			t.string :username, null: false, default: ''
			t.string :pool_key, null: false
		end
		add_index :radippool, [:pool_name, :expiry_time], name: 'radippool_poolname_expire'
		add_index :radippool, :framedipaddress, name: 'framedipaddress'
		add_index :radippool, [:nasipaddress, :pool_key, :framedipaddress], name: 'radippool_nasip_poolkey_ipaddress'
  end
end
