class RenameApiHistory < ActiveRecord::Migration
  def change
    rename_table :api_history, :api_histories
  end
end
