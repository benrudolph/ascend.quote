class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def quoted
    s = Roo::Excelx.new('test.xlsx')
    CSV.open('test2.csv', {:force_quotes => true}) do |csv|
      s.each { |row| csv << row }
    end
  end
end
