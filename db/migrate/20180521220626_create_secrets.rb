class CreateSecrets < ActiveRecord::Migration[5.2]
  def change
    create_table :secrets, id: :uuid do |t|
      t.string :recipient_email
      t.string :secret
      t.datetime :expires_at

      t.timestamps
    end
  end
end
