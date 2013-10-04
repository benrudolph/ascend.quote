require 'test_helper'

class SheetTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  def setup
    @success_sheets = []
    @success_sheets << fixture_file_upload('../sheets/success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    @success_sheets << fixture_file_upload('../sheets/success.xls','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end

  test "success sheet" do

    sheets = []

    @success_sheets.each do |sheet|
      sheets << Sheet.create({
        :sheet => sheet,
        :title => File.basename(sheet.original_filename, File.extname(sheet.original_filename))
      })
    end

    sheets.each do |sheet|
      status = sheet.status

      name_idx = status.index { |d| d[:rule] == :name }
      mobile_idx = status.index { |d| d[:rule] == :mobile }

      assert_equal :success, status[name_idx][:status]
      assert_equal :success, status[mobile_idx][:status]
    end
  end

  test "name success sheet" do
    s = fixture_file_upload('../sheets/name_success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    sheet = Sheet.create({
        :sheet => s,
        :title => 'my title'
      })

    status = sheet.status

    name_idx = status.index { |d| d[:rule] == :name }
    mobile_idx = status.index { |d| d[:rule] == :mobile }

    assert_equal :success, status[name_idx][:status]
    assert_equal :fail, status[mobile_idx][:status]
  end

  test "mobile success sheet" do
    s = fixture_file_upload('../sheets/mobile_success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    sheet = Sheet.create({
      :sheet => s,
      :title => 'my title'
    })

    status = sheet.status

    name_idx = status.index { |d| d[:rule] == :name }
    mobile_idx = status.index { |d| d[:rule] == :mobile }

    assert_equal :fail, status[name_idx][:status]
    assert_equal :success, status[mobile_idx][:status]
  end

  test "add plus signs" do
    s = fixture_file_upload('../sheets/success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    sheet = Sheet.create({
      :sheet => s,
      :title => 'my title'
    })

    ret = sheet.properly_format

    mobile_idx = 1
    CSV.foreach("#{Sheet::SHEET_PATH}/#{ret[:csv_hash]}") do |row|
      assert row[mobile_idx].starts_with? '+' unless row[mobile_idx].is_a?(String)
    end
  end


end
