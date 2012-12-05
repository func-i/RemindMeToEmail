class AddApiHistoryTable < ActiveRecord::Migration
  def change
    create_table :api_history do |t|
      t.string :api_name
      t.integer :contacts_downloaded
      t.timestamps
    end
  end
end
