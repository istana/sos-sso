class FreeradiusRadpostauth < ActiveRecord::Migration[4.2]
  def change
		create_table :radpostauth do |t|
			t.string :username, null: false, default: ''
			t.string :pass, null: false, default: ''
			t.string :reply, null: false, default: ''
			t.timestamp :authdate, null: false
		end
  end
end

