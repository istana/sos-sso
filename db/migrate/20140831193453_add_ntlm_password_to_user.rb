class AddNtlmPasswordToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ntlm_password, :string
  end
end
