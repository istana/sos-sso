class CreateGroupsUsersJoinTable < ActiveRecord::Migration
  def change
		create_table :groups_users, id: false do |t|
			t.integer :group_id, null: false
			t.integer :user_id, null: false
		end
		add_index :groups_users, [:group_id, :user_id]
  end
end
