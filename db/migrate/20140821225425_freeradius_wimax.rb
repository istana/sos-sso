# who is using WiMAX in real life?

class FreeradiusWimax < ActiveRecord::Migration
  def change
		create_table :wimax do |t|
			t.string :username, null: false, default: ''
			t.timestamp :authdate, null: false
			t.string :spi, null: false, default: ''
			t.string :mipkey, size: 400, null: false, default: ''
			t.integer :lifetime, limit: 8, default: nil
		end
		add_index :wimax, :username, name: 'username'
		add_index :wimax, :spi, name: 'spi'
  end
end
