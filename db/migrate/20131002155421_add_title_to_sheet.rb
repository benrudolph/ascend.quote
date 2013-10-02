class AddTitleToSheet < ActiveRecord::Migration
  def change
    add_column :sheets, :title, :string, default: 'mycsv'
  end
end
