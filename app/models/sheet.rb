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

  # returns csv of excel sheet with quotes and plus signs
  def properly_format
    roo_sheet = self.to_roo_sheet

    return nil unless roo_sheet

    csv_file = "#{self.filename}.csv"


    CSV.open(csv_file, 'wb', {:force_quotes => true}) do |csv|
      roo_sheet.each(headers(roo_sheet)) do |row|
        parsed_row = row.map do |pair|
          value = pair[1]
          ret = value
          # If decimal with denom of 1 then it was probably an integer
          ret = value.to_i if value.is_a?(Float) && value.denominator == 1
          if pair[0] == :"mobile number" && !value.is_a?(String)
            ret = "+#{ret}"
          end
          ret.to_s
        end
        next if (parsed_row.select { |value| !value.empty? }).length == 0
        csv << parsed_row
      end
    end

    return csv_file

  end

  def headers(roo_sheet)
    header_idx = roo_sheet.first_row
    column_start = roo_sheet.first_column
    column_end = roo_sheet.last_column

    headers = {}

    Array(column_start..column_end).each_with_index do |idx|
      value = roo_sheet.cell(header_idx, idx)
      headers[value.downcase.to_sym] = value
    end

    return headers
  end


  def status(options = {})
    status = [
      {
        :rule => :name,
        :status => :fail
      },
      {
        :rule => :mobile,
        :status => :fail
      },
      {
        :rule => :plus,
        :status => :fail
      },
    ]
    return status unless self.sheet.file?

    roo_sheet = options[:roo_sheet] || self.to_roo_sheet

    header_idx = roo_sheet.first_row
    column_start = roo_sheet.first_column
    column_end = roo_sheet.last_column


    Array(column_start..column_end).each do |idx|
      value = roo_sheet.cell(header_idx, idx)
      next unless value

      if value.downcase == "name"
        idx = status.index { |datum| datum[:rule] == :name }
        status[idx][:status] = :success
      elsif value.downcase == "mobile number"
        idx = status.index { |datum| datum[:rule] == :mobile }
        status[idx][:status] = :success
      end
    end

    return status

  end

  # returns file name without extension
  def filename
    return self.title unless self.title.empty?
    fullname = self.sheet.original_filename
    File.basename(fullname, File.extname(fullname))
  end
end
