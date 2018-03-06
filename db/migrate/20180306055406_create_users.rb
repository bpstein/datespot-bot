class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :fb_id
      t.string :full_name
      t.string :gender
      t.string :locale
      t.integer :timezone
      t.timestamps
    end
  end
end
