class AddAttachmentSheetToSheets < ActiveRecord::Migration
  def self.up
    change_table :sheets do |t|
      t.attachment :sheet
    end
  end

  def self.down
    drop_attached_file :sheets, :sheet
  end
end
