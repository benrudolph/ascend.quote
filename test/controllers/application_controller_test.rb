require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup

  end

  test "basic xlsx convertion" do
    sheet = fixture_file_upload('./test.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    post :quoted, {
      :sheet => {
        :sheet => sheet,
        :title => 'My new title'
      }
    }

    assert_response :success
  end

end
