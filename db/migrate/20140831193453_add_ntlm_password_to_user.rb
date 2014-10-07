class AddNtlmPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :ntlm_password, :string
  end
end
