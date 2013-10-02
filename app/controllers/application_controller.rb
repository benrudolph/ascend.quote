class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'csv'
  protect_from_forgery with: :exception

  def index
    @sheet = Sheet.new
  end

  def quoted
    sheet = Sheet.create(params[:sheet])
    fullname = sheet.sheet.original_filename

    roo_sheet = nil
    case File.extname(fullname)
    when '.xlsx'
      roo_sheet = Roo::Excelx.new(sheet.sheet.path)
    else
      render status: :bad_request
    end

    csv_file = "#{File.basename(fullname, File.extname(fullname))}.csv"
    CSV.open(csv_file, 'wb', {:force_quotes => true}) do |csv|
      roo_sheet.each do |row|
        parsed_row = row.map do |value|
          ret = value
          # If decimal with denom of 1 then it was probably an integer
          ret = value.to_i if value.is_a?(Float) && value.denominator == 1
          ret.to_s
        end
        next if (parsed_row.select { |value| !value.empty? }).length == 0
        csv << parsed_row
      end
    end

    send_file csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;data=#{csv_file}"

  end
end
