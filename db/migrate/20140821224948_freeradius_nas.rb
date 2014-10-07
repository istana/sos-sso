class FreeradiusNas < ActiveRecord::Migration
  def change
		create_table :nas do |t|
			t.string :nasname, null: false
			t.string :shortname
			# NOTE CHANGE
			t.string :xtype, default: 'other'
			t.integer :ports
			t.string :secret, null: false, default: 'secret'
			t.string :server
			t.string :community
			t.string :description, default: 'RADIUS Client'
		end
		add_index :nas, :nasname, name: 'nasname'
  end
end
