class FreeradiusCui < ActiveRecord::Migration[4.2]
  def change
		create_table :cui, id: false do |t|
			t.string :clientipaddress, null: false, default: ''
			t.string :callingstationid, null: false, default: ''
			t.string :username, null: false, default: ''
			t.string :cui, null: false, default: ''
			t.timestamp :lastaccounting, null: false, default: '0000-00-00 00:00:00'
		end

		execute 'ALTER TABLE cui ADD COLUMN creationdate TIMESTAMP NOT NULL DEFAULT now() AFTER cui';
		execute 'ALTER TABLE cui ADD PRIMARY KEY (username, clientipaddress, callingstationid);'
  end
end
