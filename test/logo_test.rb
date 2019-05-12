require "test_helper"

class LogoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Logo::VERSION
  end
end
