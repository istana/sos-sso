class CreateAliases < ActiveRecord::Migration[4.2]
	def change
		create_table :aliases do |t|
			t.boolean :active, default: true, null: false
			t.string :name, null: false
			t.references :user, null: false

			t.timestamps
		end
		add_index :aliases, :active
	end
end
