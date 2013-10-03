class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'csv'
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

    csv_file = sheet.properly_format

    render status: :bad_request and return unless csv_file


    send_file csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;data=#{csv_file}"

  end

end
