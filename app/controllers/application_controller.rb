class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @sheet = Sheet.new
  end

  def validate

    sheet = Sheet.create(params[:sheet])


    render :json => sheet.status
  end

  def quoted
    sheet = Sheet.create(params[:sheet])

    ret = sheet.properly_format

    render :nothing => true, status: :bad_request and return unless ret


    send_file "#{Sheet::SHEET_PATH}/#{ret[:csv_hash]}", :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;data=#{ret[:csv_file]}", :filename => ret[:csv_file]

  end

end
