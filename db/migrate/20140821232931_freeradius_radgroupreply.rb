class FreeradiusRadgroupreply < ActiveRecord::Migration[4.2]
  def change
		create_table :radgroupreply do |t|
			t.string :groupname, null: false, default: ''
			t.string :attr, null: false, default: ''
			t.string :op, limit: 2, null: false, default: '=='
			t.string :value, null: false, default: ''
		end
		execute('ALTER TABLE radgroupreply ADD KEY groupname (groupname(32));')
  end
end
