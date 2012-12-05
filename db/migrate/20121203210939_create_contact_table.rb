class CreateContactTable < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :name
      t.integer :foreign_id
      t.datetime :last_email_they_sent_at
      t.datetime :last_email_we_sent_at
      t.integer :days_before_reminder
      t.timestamps
    end
  end
end
