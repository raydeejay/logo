require 'test_helper'

# the reader takes a string and returns a list of tokens

class ReaderTest < MiniTest::Test
  def setup
    @reader = ::Logo::Reader.new
  end
  
  def test_empty_string
    assert_empty @reader.read('')
  end

  def test_numbers
    assert_equal [[:number, 23]], @reader.read('23')
    assert_equal [[:number, -23]], @reader.read('-23')
  end

  def test_quoted_word
    assert_equal [[:word, 'FOO']], @reader.read('"FOO')
    assert_equal [[:word, 'FOO']], @reader.read("'FOO")
  end

  def test_comment
    assert_equal [[:number, 23]], @reader.read('23;kl')
    assert_equal [[:number, 23]], @reader.read('23 ; kl')
    assert_equal [[:word, 'FOO']], @reader.read('"FOO;kl')
  end

  def test_variable
    assert_equal [[:variable, 'BAR']], @reader.read(':BAR')
  end

  def test_procedure
    assert_equal [[:procedure, ['TO']]], @reader.read('TO')
  end

  def test_procedure_and_numbers
    assert_equal [[:procedure, ['+', [:number, 3], [:number, 4]]]], @reader.read('+ 3 4')
  end

  def test_list
    assert_equal [[:list, [[:number, 23], [:number, 42]]]], @reader.read('[23 42]')
  end

  def test_nested_list
    assert_equal [[:list, [[:list, [[:number, 23], [:number, 42]]],
                           [:list, [[:number, 23], [:number, 42]]]]]],
                 @reader.read('[[23 42] [23 42]]')
    assert_equal [[:list, [[:list, [[:number, 23], [:number, 42]]],
                           [:list, [[:number, 23], [:number, 42]]]]]],
                 @reader.read('[ [ 23 42 ] [ 23 42 ] ]')
  end

  def test_expression_within_parens
    assert_equal [[:expression, [[:number, 3]]]], @reader.read('(3)')
  end

  def test_procedure_with_parens
    assert_equal [[:procedure, ['PRINT', [:number, 3]]]], @reader.read('(PRINT 3)')
  end

  def test_nested_procedure_calls
    assert_equal [[:procedure, ['+',
                                [:procedure, ['+', [:number, 3], [:number, 4]]],
                                [:procedure, ['+', [:number, 3], [:number, 4]]]]]],
                 @reader.read('+ + 3 4 + 3 4')
  end

  def test_nested_procedure_calls_with_parens
    assert_equal [[:procedure, ['+',
                                [:procedure, ['+', [:number, 3], [:number, 4]]],
                                [:procedure, ['+', [:number, 3], [:number, 4]]]]]],
                 @reader.read('+ (+ 3 4) + 3 4')
  end
end
