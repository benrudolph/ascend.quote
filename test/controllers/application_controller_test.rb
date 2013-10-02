require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup

  end

  test "basic xlsx convertion" do
    sheet = ActionDispatch::Http::UploadedFile.new({
      :filename => 'test.xlsx',
      :content_type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      :tempfile => File.new("#{Rails.root}/test/fixtures/test.xlsx")
    })

    post :quoted => {
      :sheet => sheet,
      :title => 'My new title'
    }

    assert_response :success
  end

end
