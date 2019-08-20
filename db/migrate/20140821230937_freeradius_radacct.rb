class FreeradiusRadacct < ActiveRecord::Migration[4.2]
  def change
		create_table :radacct, id: false do |t|
			t.integer :radacctid, limit: 8, null: false
			t.string :acctsessionid, null: false, default: ''
			t.string :acctuniqueid, null: false, default: ''
			t.string :username, null: false, default: ''
			t.string :groupname, null: false, default: ''
			t.string :realm, default: ''
			t.string :nasipaddress, null: false, default: ''
			t.string :nasportid
			t.string :nasporttype
			t.timestamp :acctstarttime
			t.timestamp :acctstoptime
			t.integer :acctsessiontime, limit: 8
			t.string :acctauthentic
			t.string :connectioninfo_start
			t.string :connectioninfo_stop
			t.integer :acctinputoctets, limit: 8
			t.integer :acctoutputoctets, limit: 8
			t.string :calledstationid, null: false, default: ''
			t.string :callingstationid, null: false, default: ''
			t.string :acctterminatecause, null: false, default: ''
			t.string :servicetype
			t.string :framedprotocol
			t.string :framedipaddress, null: false, default: ''
			t.integer :acctstartdelay, limit: 8
			t.integer :acctstopdelay, limit: 8
			t.string :xascendsessionsvrkey
		end
		execute('ALTER TABLE radacct ADD PRIMARY KEY (radacctid);')
		add_index :radacct, :acctuniqueid, unique: true, name: 'acctuniqueid'
		add_index :radacct, :username, name: 'username'
		add_index :radacct, :framedipaddress, name: 'framedipaddress'
		add_index :radacct, :acctsessionid, name: 'acctsessionid'
		add_index :radacct, :acctsessiontime, name: 'acctsessiontime'
		add_index :radacct, :acctstarttime, name: 'acctstarttime'
		add_index :radacct, :acctstoptime, name: 'acctstoptime'
		add_index :radacct, :nasipaddress, name: 'nasipaddress'
  end
end
