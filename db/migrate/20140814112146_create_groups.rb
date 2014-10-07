class CreateGroups < ActiveRecord::Migration
	def up
		create_table :groups do |t|
			t.string :name, null: false
			t.string :password, default: 'x', null: false

			t.timestamps
		end
		execute "ALTER TABLE groups ADD CONSTRAINT unqname UNIQUE(name);"
		execute "ALTER TABLE groups AUTO_INCREMENT=8000;"
	end

	def down
		drop_table :groups
	end
end
