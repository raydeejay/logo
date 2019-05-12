require 'test_helper'

class InterpreterTest < MiniTest::Test
  def setup
    @interpreter = ::Logo::Interpreter.new
  end
  
  def test_empty_string
    assert_nil @interpreter.interpret([])
  end

  def test_number
    assert_equal [:number, 23], @interpreter.interpret([[:number, 23]])
    assert_equal [:number, -23], @interpreter.interpret([[:number, -23]])
  end

  def test_simple_procedure_call
    assert_equal [:number, 7], @interpreter.interpret([[:procedure, ['+', [:number, 3], [:number, 4]]]])
  end

  def test_undefined_procedure
    err = assert_raises ::Logo::Error do
      @interpreter.interpret([[:procedure, ['FOO', [:number, 3], [:number, 4]]]])
    end
    assert_equal 'Error: Undefined procedure FOO', err.message
  end

  def test_nested_procedure_call
    assert_equal [:number, 14],
                 @interpreter.interpret([[:procedure, ['+',
                                                       [:procedure, ['+', [:number, 3], [:number, 4]]],
                                                       [:procedure, ['+', [:number, 3], [:number, 4]]]]]])
  end
end
