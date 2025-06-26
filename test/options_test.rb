class OptionsTest < Minitest::Test

  def test_version
    options = RubyLiveReload::Options.parse "-v"

    assert_equal options.message, RubyLiveReload::VERSION
  end

end
