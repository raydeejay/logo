require 'test_helper'

class BuiltinsTest < ::MiniTest::Test
  def setup
    @builtins = ::Logo::Builtins.new
  end

  # 2.1 Constructors
  def test_word
    assert_equal [:word, 'FOOBAR'], @builtins.word([:word, 'FOO'], [:word, 'BAR'])
    assert_equal [:word, 'FOOBARBAZ'], @builtins.word([:word, 'FOO'], [:word, 'BAR'], [:word, 'BAZ'])
  end

  def test_list
    assert_equal [:list, [[:number, 3]]], @builtins.list([:number, 3])
    assert_equal [:list, [[:number, 3], [:number, 4]]], @builtins.list([:number, 3], [:number, 4])
    assert_equal [:list, [[:number, 3], [:number, 4], [:number, 5]]],
                 @builtins.list([:number, 3], [:number, 4], [:number, 5])
  end

  def test_sentence
    assert_equal [:list, [[:number, 3]]], @builtins.sentence([:list, [[:number, 3]]])
    assert_equal [:list, [[:number, 3], [:number, 4]]],
                 @builtins.sentence([:list, [[:number, 3]]],
                                    [:list, [[:number, 4]]])
    assert_equal [:list, [[:number, 3], [:number, 4], [:number, 5]]],
                 @builtins.sentence([:list, [[:number, 3]]],
                                    [:list, [[:number, 4]]],
                                    [:list, [[:number, 5]]])
  end

  # 2.2 Data selectors
  def test_first
    assert_nil @builtins.first
    assert_nil @builtins.first([:list, []])
    assert_equal [:number, 3], @builtins.first([:list, [[:number, 3]]])
    assert_equal [:number, 3], @builtins.first([:list, [[:number, 3], [:number, 4]]])
  end

  def test_last
    assert_nil @builtins.last
    assert_nil @builtins.last([:list, []])
    assert_equal [:number, 3], @builtins.last([:list, [[:number, 3]]])
    assert_equal [:number, 4], @builtins.last([:list, [[:number, 3], [:number, 4]]])
  end

  # 4. Arithmetic
  # 4.1 Numeric operations
  def test_plus
    assert_equal [:number, 0], @builtins.+
    assert_equal [:number, 7], @builtins.+([:number, 7])
    assert_equal [:number, 7], @builtins.+([:number, 3], [:number, 4])
    assert_equal [:number, 7], @builtins.+([:number, 1], [:number, 2], [:number, 4])
    assert_equal [:number, 7], @builtins.+([:number, 2], [:number, 3], [:number, 4], [:number, -2])
  end
end
