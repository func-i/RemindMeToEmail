class AddTagsTable < ActiveRecord::Migration
  def change
    add_column :contacts, :tags, :string
  end
end
