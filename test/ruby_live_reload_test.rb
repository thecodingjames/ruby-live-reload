class RubyLiveReloadTest < Minitest::Test

  def test_message
    assert_output(/Usage:/) do
      RubyLiveReload.run "-x"
    end
  end

  def test_server
    assert_output(/running/) do
      RubyLiveReload.run
    end
  end

end
