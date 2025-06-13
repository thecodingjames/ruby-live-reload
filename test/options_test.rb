class OptionsTest < Minitest::Test

  def test_version
    options = Options.parse "-v"

    assert_equal options.message, VERSION
  end

end
