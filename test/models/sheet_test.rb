require 'test_helper'

class SheetTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  def setup
  end

  test "success sheet" do
    s = fixture_file_upload('./success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    sheet = Sheet.create({
        :sheet => s,
        :title => 'my title'
      })

    status = sheet.status

    name_idx = status.index { |d| d[:rule] == :name }
    mobile_idx = status.index { |d| d[:rule] == :mobile }
    plus_idx = status.index { |d| d[:rule] == :plus }

    assert_equal :success, status[name_idx][:status]
    assert_equal :success, status[mobile_idx][:status]
    assert_equal :fail, status[plus_idx][:status]
  end

  test "name success sheet" do
    s = fixture_file_upload('name_success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    sheet = Sheet.create({
        :sheet => s,
        :title => 'my title'
      })

    status = sheet.status

    name_idx = status.index { |d| d[:rule] == :name }
    mobile_idx = status.index { |d| d[:rule] == :mobile }
    plus_idx = status.index { |d| d[:rule] == :plus }

    assert_equal :success, status[name_idx][:status]
    assert_equal :fail, status[mobile_idx][:status]
    assert_equal :fail, status[plus_idx][:status]
  end

  test "mobile success sheet" do
    s = fixture_file_upload('mobile_success.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    sheet = Sheet.create({
        :sheet => s,
        :title => 'my title'
      })

    status = sheet.status

    name_idx = status.index { |d| d[:rule] == :name }
    mobile_idx = status.index { |d| d[:rule] == :mobile }
    plus_idx = status.index { |d| d[:rule] == :plus }

    assert_equal :fail, status[name_idx][:status]
    assert_equal :success, status[mobile_idx][:status]
    assert_equal :fail, status[plus_idx][:status]
  end
end
