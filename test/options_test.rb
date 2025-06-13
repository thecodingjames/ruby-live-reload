class OptionsTest < Minitest::Test

  def test_version
    assert_output "#{VERSION}\n" do
      p "crashing test"
      # Options.parse "-v"
    end
  end

end
