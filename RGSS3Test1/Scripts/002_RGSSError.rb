class TestRGSSError

  def test_class
    assert_equal(RGSSError.superclass, StandardError)
  end
end

run_test(TestRGSSError)
