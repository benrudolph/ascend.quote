class ChangeColumnDefaultSheets < ActiveRecord::Migration
  def change
    change_column_default :sheets, :title, nil
  end
end
