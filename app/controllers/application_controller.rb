class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'csv'
  protect_from_forgery with: :exception

  def index
    @sheet = Sheet.new
  end

  def validate
    status = {
      :name => false,
      :mobile_number => false,
      :plus => false
    }

    sheet = Sheet.create(params[:sheet])

    roo_sheet = sheet.to_roo_sheet

    render status: :bad_request and return unless roo_sheet

    header_idx = roo_sheet.first_row
    column_start = roo_sheet.first_column
    column_end = roo_sheet.column_end

    [column_start..column_end].each do |idx|
      value = roo_sheet.cell(header_idx, idx)

      if value.downcase == "name"
        status[:name] = true
      elsif value.downcase == "mobile number"
        status[:mobile_number] = true
      end
    end

    render :json => status
  end

  def quoted
    sheet = Sheet.create(params[:sheet])

    roo_sheet = sheet.to_roo_sheet

    render status: :bad_request and return unless roo_sheet

    csv_file = "#{sheet.filename}.csv"
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
