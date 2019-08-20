class FreeradiusRadreply < ActiveRecord::Migration[4.2]
  def change
		create_table :radreply do |t|
			t.string :username, null: false, default: ''
			t.string :attr, null: false, default: ''
			t.string :op, limit: 2, null: false, default: '=='
			t.string :value, null: false, default: ''
		end
		execute('ALTER TABLE radreply ADD KEY username (username(32));')
  end
end
