class Sheet < ActiveRecord::Base
  attr_accessible :sheet, :title
  has_attached_file :sheet
  validates_attachment :sheet, :presence => true,
      :content_type => { :content_type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }

  def to_roo_sheet

    fullname = self.sheet.original_filename

    roo_sheet = nil
    case File.extname(fullname)
    when '.xlsx'
      roo_sheet = Roo::Excelx.new(sheet.path)
    when '.xls'
      roo_sheet = Roo::Excel.new(sheet.path)
    when '.csv'
      roo_sheet = Roo::CSV.new(sheet.path)
    when '.ods'
      roo_sheet = Roo::OpenOffice.new(sheet.path)
    end

    return roo_sheet

  end

  # returns file name without extension
  def filename
    return self.title unless self.title.empty?
    fullname = self.sheet.original_filename
    File.basename(fullname, File.extname(fullname))
  end
end
