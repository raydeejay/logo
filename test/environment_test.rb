require 'test_helper'

class EnvironmentTest < ::Minitest::Test
  def setup
    @env = ::Logo::Environment.new
  end

  def test_empty
    assert_empty @env.contents
  end

  def test_add_binding
    @env[:foo] = 3
    assert_equal 3, @env[:foo]
  end

  def test_undefined_binding
    err = assert_raises ::Logo::Error do
      @env[:foo]
    end
    assert_equal 'Error: Undefined binding foo', err.message
  end

  def test_replace_binding
    @env[:foo] = 3
    @env[:foo] = 7
    assert_equal 7, @env[:foo]
  end

  def test_erase_binding
    @env[:foo] = 5
    @env.delete :foo
    assert_empty @env.contents
  end

  def test_erase_undefined_binding
    err = assert_raises ::Logo::Error do
      @env.delete :foo
    end
    assert_equal 'Error: Undefined binding foo', err.message
  end

  def test_derive_environment
    @env[:foo] = 7
    e2 = @env.class.new @env
    assert_equal @env, e2.parent
    assert_equal 7, e2[:foo]
  end

  def test_bindings_default_to_global
    @env[:foo] = 7
    e2 = @env.class.new @env
    e2[:foo] = 9
    assert_equal 9, @env[:foo]
    assert_equal 9, e2[:foo]
  end

  def test_local_bindings
    @env[:foo] = 7
    e2 = @env.class.new @env
    e2.create :foo
    e2[:foo] = 9
    assert_equal 7, @env[:foo]
    assert_equal 9, e2[:foo]
  end

  def test_erase_local_binding
    @env[:foo] = 7
    e2 = @env.class.new @env
    e2.create :foo
    e2[:foo] = 9
    e2.delete :foo
    assert_equal 7, e2[:foo]
  end

  def test_erase_global_binding
    @env[:foo] = 7
    e2 = @env.class.new @env
    e2[:foo] = 9
    e2.delete :foo
    err = assert_raises ::Logo::Error do
      @env[:foo]
    end
    assert_equal 'Error: Undefined binding foo', err.message
  end
end
