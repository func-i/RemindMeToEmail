class ChangeContactAtToBoth < ActiveRecord::Migration
  def change
    rename_column :contacts, :last_email_we_sent_at, :last_email_at
    remove_column :contacts, :last_email_they_sent_at
  end
end
