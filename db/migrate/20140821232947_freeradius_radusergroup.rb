class FreeradiusRadusergroup < ActiveRecord::Migration
  def change
		create_table :radusergroup, id: false do |t|
			t.string :username, null: false, default: ''
			t.string :groupname, null: false, default: ''
			t.integer :priority, null: false, default: '1'
		end
		execute('ALTER TABLE radusergroup ADD KEY username (username(32));')
  end
end
