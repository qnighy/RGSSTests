class TestRect

  class BareRect < Rect
    def initialize; end
  end

  def test_class
    assert_equal(Rect.superclass, Object)
  end

  def fields(r)
    [r.x, r.y, r.width, r.height]
  end

  def test_constructor
    assert_equal(fields(Rect.new(1, 2, 3, 4)), [1, 2, 3, 4])
    assert_equal(fields(Rect.new(1, 2, -300, -400)), [1, 2, -300, -400])
    assert_equal(fields(Rect.new(-100, -2000, -300, -400)), [-100, -2000, -300, -400])
    assert_equal(fields(Rect.new), [0, 0, 0, 0])
    assert_equal(fields(Rect.new(1.5, 2.5, 3.5, 4.5)), [1, 2, 3, 4])
    assert_raise(ArgumentError) { Rect.new(1) }
    assert_raise(ArgumentError) { Rect.new(1, 2) }
    assert_raise(ArgumentError) { Rect.new(1, 2, 3) }
    assert_raise(ArgumentError) { Rect.new(1, 2, 3, 4, 5) }
    assert_raise(TypeError) { Rect.new("1", 2, 3, 4) }
    assert_raise(TypeError) { Rect.new(1, "2", 3, 4) }
    assert_raise(TypeError) { Rect.new(1, 2, "3", 4) }
    assert_raise(TypeError) { Rect.new(1, 2, 3, "4") }
    assert_raise(RangeError) {Rect.new(1, 2, 3, 0.0/0.0)}
    assert_raise(RangeError) {Rect.new(1, 2, 3, 1.0/0.0)}
    Rect.new(1, 2, 3, (1<<31)-1)
    assert_raise(RangeError) {Rect.new(1, 2, 3, (1<<31))}
    Rect.new(1, 2, 3, -(1<<31))
    assert_raise(RangeError) {Rect.new(1, 2, 3, -(1<<31)-1)}
    assert(Integer === Rect.new(1.5, 2.5, 3.5, 4.5).x)
    assert(Integer === Rect.new(1.5, 2.5, 3.5, 4.5).y)
    assert(Integer === Rect.new(1.5, 2.5, 3.5, 4.5).width)
    assert(Integer === Rect.new(1.5, 2.5, 3.5, 4.5).height)
  end

  def test_equality
    assert_equal(Rect.new(1, 2, 3, 4), Rect.new(1, 2, 3, 4))
    assert_not_equal(Rect.new(1, 2, 3, 4), 1)
    assert_not_equal(Rect.new(1, 2, 3, 4), "foo")
    assert_not_equal(Rect.new(1, 2, 3, 4), [1])
    assert_not_equal(Rect.new(1, 2, 3, 4), :foo)
    assert_not_equal(Rect.new(1, 2, 3, 4), Object.new)
    assert_not_equal(Rect.new(11, 2, 3, 4), Rect.new(1, 2, 3, 4))
    assert_not_equal(Rect.new(1, 12, 3, 4), Rect.new(1, 2, 3, 4))
    assert_not_equal(Rect.new(1, 2, 13, 4), Rect.new(1, 2, 3, 4))
    assert_not_equal(Rect.new(1, 2, 3, 14), Rect.new(1, 2, 3, 4))
    assert_not_same(Rect.new(1, 2, 3, 4), Rect.new(1, 2, 3, 4))
  end

  def test_set
    r = Rect.new
    assert_same(r, r.set(1, 2, 3, 4))
    assert_same(r, r.set(Rect.new))

    assert_equal(fields(Rect.new.set(1, 2, 3, 4)), [1, 2, 3, 4])
    assert_equal(fields(Rect.new.set(1, 2, -300, -400)), [1, 2, -300, -400])
    assert_equal(fields(Rect.new.set(-100, -2000, -300, -400)), [-100, -2000, -300, -400])
    assert_equal(fields(Rect.new.set(1.5, 2.5, 3.5, 4.5)), [1, 2, 3, 4])
    assert_raise(ArgumentError) { Rect.new.set }
    assert_raise(ArgumentError) { Rect.new.set(1, 2) }
    assert_raise(ArgumentError) { Rect.new.set(1, 2, 3) }
    assert_raise(ArgumentError) { Rect.new.set(1, 2, 3, 4, 5) }
    assert_raise(TypeError) { Rect.new.set("1", 2, 3, 4) }
    assert_raise(TypeError) { Rect.new.set(1, "2", 3, 4) }
    assert_raise(TypeError) { Rect.new.set(1, 2, "3", 4) }
    assert_raise(TypeError) { Rect.new.set(1, 2, 3, "4") }
    assert_raise(TypeError) { Rect.new.set(1) }
    assert_raise(RangeError) {Rect.new.set(1, 2, 3, 0.0/0.0)}
    assert_raise(RangeError) {Rect.new.set(1, 2, 3, 1.0/0.0)}
    Rect.new.set(1, 2, 3, (1<<31)-1)
    assert_raise(RangeError) {Rect.new.set(1, 2, 3, (1<<31))}
    Rect.new.set(1, 2, 3, -(1<<31))
    assert_raise(RangeError) {Rect.new.set(1, 2, 3, -(1<<31)-1)}
  end

  def test_empty
    r = Rect.new
    assert_same(r, r.empty)

    assert_equal(fields(Rect.new(1, 2, 3, 4).empty), [0, 0, 0, 0])
  end

  def test_getters
    # Getters
    assert_raise(ArgumentError) { Rect.new.x(1) }
    assert_raise(ArgumentError) { Rect.new.y(2) }
    assert_raise(ArgumentError) { Rect.new.width(3) }
    assert_raise(ArgumentError) { Rect.new.height(4) }
  end

  def test_setters
    # Setters return the argument.
    r = Rect.new
    assert_equal(1, r.x = 1)
    assert_equal(2, r.y = 2)
    assert_equal(3, r.width = 3)
    assert_equal(4, r.height = 4)
    assert(Float === (r.x = 1.5))
    assert(Float === (r.y = 2.5))
    assert(Float === (r.width = 3.5))
    assert(Float === (r.height = 4.5))

    # Setters
    assert_equal(fields(Rect.new.tap{|r|r.x = 1}), [1, 0, 0, 0])
    assert_equal(fields(Rect.new.tap{|r|r.y = 2}), [0, 2, 0, 0])
    assert_equal(fields(Rect.new.tap{|r|r.width = 3}), [0, 0, 3, 0])
    assert_equal(fields(Rect.new.tap{|r|r.height = 4}), [0, 0, 0, 4])
  end

  def test_to_s
    assert_equal(Rect.new(1, 2, 3, 4).to_s,
                 "(1, 2, 3, 4)")
    assert_equal(Rect.new(0, 0, 0, 0).to_s,
                 "(0, 0, 0, 0)")
    assert_equal(Rect.new(-1, -2, -3, -4).to_s,
                 "(-1, -2, -3, -4)")
    assert_equal(Rect.new(1, 2, 3, 4).inspect,
                 "(1, 2, 3, 4)")
    assert_equal(Rect.new(0, 0, 0, 0).inspect,
                 "(0, 0, 0, 0)")
    assert_equal(Rect.new(-1, -2, -3, -4).inspect,
                 "(-1, -2, -3, -4)")
  end

  def test_initialize_copy
    # initialize_copy is private
    assert_raise(NoMethodError) {Rect.new.initialize_copy}

    # initialize_copy behaves like set.
    assert_equal(
      fields(Rect.new.tap{|r|r.send(:initialize_copy,
                                     Rect.new(1, 2, 3, 4))}),
      [1, 2, 3, 4])
  end

  def test_load
    # _load
    assert_equal(fields(Rect._load([1, 2, 3, 4].pack('V*'))),
                 [1, 2, 3, 4])
    assert_equal(fields(Rect._load([-1, -2, -3, -4].pack('V*'))),
                 [-1, -2, -3, -4])
  end

  def test_dump
    # _dump
    assert_equal(Rect.new(1, 2, 3, 4)._dump(1),
                 [1, 2, 3, 4].pack('V*'))
    assert_equal(Rect.new(-1, -2, -3, -4)._dump(1),
                 [-1, -2, -3, -4].pack('V*'))
    assert_equal(Rect.new(1, 2, 3, 4)._dump(0),
                 [1, 2, 3, 4].pack('V*'))
    assert_equal(Rect.new(1, 2, 3, 4)._dump(-1),
                 [1, 2, 3, 4].pack('V*'))
  end

  def test_freeze_buggy
    # Freeze [BUGGY BEHAVIOR]
    r = Rect.new
    r.freeze
    assert(r.frozen?)
    r.x = 1
    r.y = 2
    r.width = 3
    r.height = 4
    assert_equal(fields(r), [1, 2, 3, 4])
    r.set(11, 12, 13, 14)
    assert_equal(fields(r), [11, 12, 13, 14])
    r.set(Rect.new(31, 32, 33, 34))
    assert_equal(fields(r), [31, 32, 33, 34])
    r.empty
    assert_equal(fields(r), [0, 0, 0, 0])
  end

  def test_allocator
    assert(fields(BareRect.new) == [0, 0, 0, 0])
    r = BareRect.new
    r.set(1, 2, 3, 4)
    assert_equal(fields(r), [1, 2, 3, 4])
    assert_equal(r.send(:initialize), nil)
    assert_equal(fields(r), [1, 2, 3, 4])
  end

  def test_typechecking
    r = Rect.new
    assert_nothing_raised(TypeError) { r.set(Color.new) }
    assert_raise_with_message(TypeError, "wrong argument type Object (expected Data)") { r.set(Object.new) }
  end

  def test_argchecking
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 1)") { Rect.new(1) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 2)") { Rect.new(1, 2) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 3)") { Rect.new(1, 2, 3) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 5)") { Rect.new(1, 2, 3, 4, 5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 0)") { Rect.new.set }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 2)") { Rect.new.set(1, 2) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 3)") { Rect.new.set(1, 2, 3) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 5)") { Rect.new.set(1, 2, 3, 4, 5) }
  end
end

run_test(TestRect)
