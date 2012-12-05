class ChangeForeignIdToExternalId < ActiveRecord::Migration
  def change
    rename_column :contacts, :foreign_id, :external_id
  end
end
