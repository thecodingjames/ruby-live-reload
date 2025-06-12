
class OptionsTest < Minitest::Test

  def setup
  end

  def test_version
    options = Options.parse([])
    p options
  end

end
