require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup

  end

  test "basic xlsx convertion" do
    sheet = fixture_file_upload('../sheets/test.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    post :quoted, {
      :sheet => {
        :sheet => sheet,
        :title => 'My new title'
      }
    }

    assert_response :success
  end

  test "real cases validation" do

    sheetnames = Dir['test/sheets/real/*']

    sheetfiles = sheetnames.map { |name| fixture_file_upload("../sheets/real/#{File.basename(name)}", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    sheetfiles.each do |file|
      post :validate, {
        :sheet => {
          :sheet => file,
          :title => 'My title'
        }
      }

      assert_response :success
    end

  end

  test "No sheet uploaded quoted" do

    post :quoted, {
      :sheet => {
        :sheet => nil,
        :title => 'My title'
      }
    }

    assert_response :bad_request

  end

  test "No sheet uploaded validate" do
    post :validate, {
      :sheet => {
        :sheet => nil,
        :title => 'My title'
      }
    }

    assert_response :success
  end

  test "real cases convertion" do

    sheetnames = Dir['../real/*']

    sheetfiles = sheetnames.map { |name| fixture_file_upload("../sheets/real/#{File.basename(name)}", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    sheetfiles.each do |file|
      post :quoted, {
        :sheet => {
          :sheet => file,
          :title => 'My title'
        }
      }

      assert_response :success
    end

  end



end
