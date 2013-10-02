class AddAttachmentCsvToSheets < ActiveRecord::Migration
  def self.up
    change_table :sheets do |t|
      t.attachment :csv
    end
  end

  def self.down
    drop_attached_file :sheets, :csv
  end
end
