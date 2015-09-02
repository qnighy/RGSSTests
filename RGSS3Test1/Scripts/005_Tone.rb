class TestTone

  class BareTone < Tone
    def initialize; end
  end

  def test_class
    assert_equal(Tone.superclass, Object)
  end

  def fields(t)
    [t.red, t.green, t.blue, t.gray]
  end

  def test_constructor
    assert_equal(fields(Tone.new(1.5, 2.5, 3.5, 4.5)), [1.5, 2.5, 3.5, 4.5])
    assert_equal(fields(Tone.new(1.5, 2.5, 3.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new), [0.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Tone.new(1, 2, 3, 4)), [1.0, 2.0, 3.0, 4.0])
    assert_equal(fields(Tone.new(1, 2, 3)), [1.0, 2.0, 3.0, 0.0])
    assert_raise(ArgumentError) { Tone.new(1.5) }
    assert_raise(ArgumentError) { Tone.new(1.5, 2.5) }
    assert_raise(ArgumentError) { Tone.new(1.5, 2.5, 3.5, 4.5, 5.5) }
    assert_raise(TypeError) { Tone.new("1.5", 2.5, 3.5, 4.5) }
    assert_raise(TypeError) { Tone.new(1.5, "2.5", 3.5, 4.5) }
    assert_raise(TypeError) { Tone.new(1.5, 2.5, "3.5", 4.5) }
    assert_raise(TypeError) { Tone.new(1.5, 2.5, 3.5, "4.5") }
    assert_raise(TypeError) { Tone.new("1.5", 2.5, 3.5) }
    assert_raise(TypeError) { Tone.new(1.5, "2.5", 3.5) }
    assert_raise(TypeError) { Tone.new(1.5, 2.5, "3.5") }
    assert(Float === Tone.new(1, 2, 3, 4).red)
    assert(Float === Tone.new(1, 2, 3, 4).green)
    assert(Float === Tone.new(1, 2, 3, 4).blue)
    assert(Float === Tone.new(1, 2, 3, 4).gray)
    assert(Float === Tone.new(1, 2, 3).red)
    assert(Float === Tone.new(1, 2, 3).green)
    assert(Float === Tone.new(1, 2, 3).blue)
    assert(Float === Tone.new(1, 2, 3).gray)
  end

  def test_constructor_saturation_lb
    # Constructor saturates toward 0.0
    assert_equal(fields(Tone.new(-301.5, 2.5, 3.5, 4.5)), [-255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Tone.new(1.5, -302.5, 3.5, 4.5)), [1.5, -255.0, 3.5, 4.5])
    assert_equal(fields(Tone.new(1.5, 2.5, -303.5, 4.5)), [1.5, 2.5, -255.0, 4.5])
    assert_equal(fields(Tone.new(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new(-301.5, 2.5, 3.5)), [-255.0, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new(1.5, -302.5, 3.5)), [1.5, -255.0, 3.5, 0.0])
    assert_equal(fields(Tone.new(1.5, 2.5, -303.5)), [1.5, 2.5, -255.0, 0.0])
  end

  def test_constructor_saturation_ub
    # Constructor saturates toward 255.0
    assert_equal(fields(Tone.new(301.5, 2.5, 3.5, 4.5)), [255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Tone.new(1.5, 302.5, 3.5, 4.5)), [1.5, 255.0, 3.5, 4.5])
    assert_equal(fields(Tone.new(1.5, 2.5, 303.5, 4.5)), [1.5, 2.5, 255.0, 4.5])
    assert_equal(fields(Tone.new(1.5, 2.5, 3.5, 304.5)), [1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Tone.new(301.5, 2.5, 3.5)), [255.0, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new(1.5, 302.5, 3.5)), [1.5, 255.0, 3.5, 0.0])
    assert_equal(fields(Tone.new(1.5, 2.5, 303.5)), [1.5, 2.5, 255.0, 0.0])
  end

  def test_equality
    # Tone is equal when red, green, blue and gray is equal.
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 4.5), 1)
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 4.5), "foo")
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 4.5), [1])
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 4.5), :foo)
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 4.5), Object.new)
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 4.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Tone.new(11.5, 2.5, 3.5, 4.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Tone.new(1.5, 12.5, 3.5, 4.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Tone.new(1.5, 2.5, 13.5, 4.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Tone.new(1.5, 2.5, 3.5, 14.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_not_same(Tone.new(1.5, 2.5, 3.5, 4.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5) <=> Tone.new(1.5, 2.5, 3.5, 4.5), 0)
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5) <=> Tone.new(1.5, 2.5, 3.5, 14.5), nil)
  end

  def test_set
    t = Tone.new
    assert_same(t, t.set)
    assert_same(t, t.set(Tone.new))
    assert_same(t, t.set(1.5, 2.5, 3.5))
    assert_same(t, t.set(1.5, 2.5, 3.5, 4.5))

    assert_equal(fields(Tone.new.set(1.5, 2.5, 3.5, 4.5)), [1.5, 2.5, 3.5, 4.5])
    assert_equal(fields(Tone.new.set(1.5, 2.5, 3.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new(1.5, 2.5, 3.5, 4.5).set), [0.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Tone.new.set(Tone.new(1.5, 2.5, 3.5, 4.5))),
                 [1.5, 2.5, 3.5, 4.5])
    assert_raise(ArgumentError) { Tone.new.set(1.5, 2.5) }
    assert_raise(ArgumentError) { Tone.new.set(1.5, 2.5, 3.5, 4.5, 5.5) }
    assert_raise(TypeError) { Tone.new.set("1.5", 2.5, 3.5, 4.5) }
    assert_raise(TypeError) { Tone.new.set(1.5, "2.5", 3.5, 4.5) }
    assert_raise(TypeError) { Tone.new.set(1.5, 2.5, "3.5", 4.5) }
    assert_raise(TypeError) { Tone.new.set(1.5, 2.5, 3.5, "4.5") }
    assert_raise(TypeError) { Tone.new.set("1.5", 2.5, 3.5) }
    assert_raise(TypeError) { Tone.new.set(1.5, "2.5", 3.5) }
    assert_raise(TypeError) { Tone.new.set(1.5, 2.5, "3.5") }
    assert_raise(TypeError) { Tone.new.set(1.5) }
    assert(Float === Tone.new.set(1, 2, 3, 4).red)
    assert(Float === Tone.new.set(1, 2, 3, 4).green)
    assert(Float === Tone.new.set(1, 2, 3, 4).blue)
    assert(Float === Tone.new.set(1, 2, 3, 4).gray)
    assert(Float === Tone.new.set(1, 2, 3).red)
    assert(Float === Tone.new.set(1, 2, 3).green)
    assert(Float === Tone.new.set(1, 2, 3).blue)
    assert(Float === Tone.new.set(1, 2, 3).gray)

    t1 = Tone.new
    t2 = Tone.new(1.5, 2.5, 3.5, 4.5)
    t1.set(t2)
    t1.red = 11.5
    assert_equal(t2.red, 1.5)
    t2.green = 12.5
    assert_equal(t1.green, 2.5)
  end

  def test_set_saturation_lb
    # Setters saturate toward 0.0.
    assert_equal(fields(Tone.new.set(-301.5, 2.5, 3.5, 4.5)), [-255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Tone.new.set(1.5, -302.5, 3.5, 4.5)), [1.5, -255.0, 3.5, 4.5])
    assert_equal(fields(Tone.new.set(1.5, 2.5, -303.5, 4.5)), [1.5, 2.5, -255.0, 4.5])
    assert_equal(fields(Tone.new.set(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new.set(-301.5, 2.5, 3.5)), [-255.0, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new.set(1.5, -302.5, 3.5)), [1.5, -255.0, 3.5, 0.0])
    assert_equal(fields(Tone.new.set(1.5, 2.5, -303.5)), [1.5, 2.5, -255.0, 0.0])
  end

  def test_set_saturation_ub
    # Setters saturate toward 255.0
    assert_equal(fields(Tone.new.set(301.5, 2.5, 3.5, 4.5)), [255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Tone.new.set(1.5, 302.5, 3.5, 4.5)), [1.5, 255.0, 3.5, 4.5])
    assert_equal(fields(Tone.new.set(1.5, 2.5, 303.5, 4.5)), [1.5, 2.5, 255.0, 4.5])
    assert_equal(fields(Tone.new.set(1.5, 2.5, 3.5, 304.5)), [1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Tone.new.set(301.5, 2.5, 3.5)), [255.0, 2.5, 3.5, 0.0])
    assert_equal(fields(Tone.new.set(1.5, 302.5, 3.5)), [1.5, 255.0, 3.5, 0.0])
    assert_equal(fields(Tone.new.set(1.5, 2.5, 303.5)), [1.5, 2.5, 255.0, 0.0])
  end

  def test_getters
    # Getters
    assert_raise(ArgumentError) { Tone.new.red(1.5) }
    assert_raise(ArgumentError) { Tone.new.green(1.5) }
    assert_raise(ArgumentError) { Tone.new.blue(1.5) }
    assert_raise(ArgumentError) { Tone.new.gray(1.5) }
  end

  def test_setters
    # Setters return the argument.
    t = Tone.new
    assert_equal(1.5, t.red = 1.5)
    assert_equal(2.5, t.green = 2.5)
    assert_equal(3.5, t.blue = 3.5)
    assert_equal(4.5, t.gray = 4.5)
    assert(Integer === (t.red = 1))
    assert(Integer === (t.green = 2))
    assert(Integer === (t.blue = 3))
    assert(Integer === (t.gray = 4))

    # Setters
    assert_equal(fields(Tone.new.tap{|t|t.red = 1.5}), [1.5, 0.0, 0.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.green = 2.5}), [0.0, 2.5, 0.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.blue = 3.5}), [0.0, 0.0, 3.5, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.gray = 4.5}), [0.0, 0.0, 0.0, 4.5])
  end

  def test_setters_saturation_lb
    # Setters saturate toward 0.0
    # RGSS BUG: it doesn't saturate R/G/B actually.
    assert_equal(fields(Tone.new.tap{|t|t.red = -301.5}), [-255.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.green = -302.5}), [0.0, -255.0, 0.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.blue = -303.5}), [0.0, 0.0, -255.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.gray = -4.5}), [0.0, 0.0, 0.0, 0.0])
  end

  def test_setters_saturation_ub
    # Setters saturate toward 255.0
    assert_equal(fields(Tone.new.tap{|t|t.red = 301.5}), [255.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.green = 302.5}), [0.0, 255.0, 0.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.blue = 303.5}), [0.0, 0.0, 255.0, 0.0])
    assert_equal(fields(Tone.new.tap{|t|t.gray = 304.5}), [0.0, 0.0, 0.0, 255.0])
  end

  def test_to_s
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5).to_s,
                 "(1.500000, 2.500000, 3.500000, 4.500000)")
    assert_equal(Tone.new(201.5, 202.5, 203.5, 204.5).to_s,
                 "(201.500000, 202.500000, 203.500000, 204.500000)")
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5).inspect,
                 "(1.500000, 2.500000, 3.500000, 4.500000)")
    assert_equal(Tone.new(201.5, 202.5, 203.5, 204.5).inspect,
                 "(201.500000, 202.500000, 203.500000, 204.500000)")
  end

  def test_initialize_copy
    # initialize_copy is private
    assert_raise(NoMethodError) {Tone.new.initialize_copy}

    # initialize_copy behaves like set.
    assert_equal(
      fields(Tone.new.tap{|t|t.send(:initialize_copy,
                                     Tone.new(1.5, 2.5, 3.5, 4.5))}),
      [1.5, 2.5, 3.5, 4.5])
  end

  def test_load
    # _load
    assert_equal(fields(Tone._load([1.5, 2.5, 3.5, 4.5].pack('E*'))),
                 [1.5, 2.5, 3.5, 4.5])
  end

  def test_dump
    # _dump
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5)._dump(1),
                 [1.5, 2.5, 3.5, 4.5].pack('E*'))
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5)._dump(0),
                 [1.5, 2.5, 3.5, 4.5].pack('E*'))
    assert_equal(Tone.new(1.5, 2.5, 3.5, 4.5)._dump(-1),
                 [1.5, 2.5, 3.5, 4.5].pack('E*'))
  end

  def test_load_saturation_buggy
    assert_equal(fields(Tone._load([-301.5, -302.5, -303.5, -4.5].pack('E*'))),
                 [-301.5, -302.5, -303.5, -4.5])
    assert_equal(fields(Tone._load([301.5, 302.5, 303.5, 304.5].pack('E*'))),
                 [301.5, 302.5, 303.5, 304.5])
  end

  def test_freeze_buggy
    # Freeze [BUGGY BEHAVIOR]
    t = Tone.new
    t.freeze
    assert(t.frozen?)
    t.red = 1.5
    t.green = 2.5
    t.blue = 3.5
    t.gray = 4.5
    assert_equal(fields(t), [1.5, 2.5, 3.5, 4.5])
    t.set(11.5, 12.5, 13.5, 14.5)
    assert_equal(fields(t), [11.5, 12.5, 13.5, 14.5])
    t.set(21.5, 22.5, 23.5)
    assert_equal(fields(t), [21.5, 22.5, 23.5, 0.0])
    t.set(Tone.new(31.5, 32.5, 33.5, 34.5))
    assert_equal(fields(t), [31.5, 32.5, 33.5, 34.5])
    t.set
    assert_equal(fields(t), [0.0, 0.0, 0.0, 0.0])
  end

  def construct_load(red, green, blue, gray)
    Tone._load([red, green, blue, gray].pack('E*'))
  end

  def test_cloning_saturation_buggy
    assert_equal(
      fields(Tone.new.tap{|t|t.set(construct_load(-301.5, -302.5, -303.5, -304.5))}),
      [-301.5, -302.5, -303.5, -304.5])
    assert_equal(
      fields(
        Tone.new.tap{|t|t.set(construct_load(301.5, 302.5, 303.5, 304.5))}),
      [301.5, 302.5, 303.5, 304.5])
    assert_equal(
      fields(
        Tone.new.tap{|t|t.send(:initialize_copy,
                                construct_load(-301.5, -302.5, -303.5, -304.5))}),
      [-301.5, -302.5, -303.5, -304.5])
    assert_equal(
      fields(
        Tone.new.tap{|t|t.send(:initialize_copy,
                                construct_load(301.5, 302.5, 303.5, 304.5))}),
      [301.5, 302.5, 303.5, 304.5])
  end

  def test_allocator
    assert(fields(BareTone.new) == [0.0, 0.0, 0.0, 0.0])
    t = BareTone.new
    t.set(1.5, 2.5, 3.5, 4.5)
    assert_equal(fields(t), [1.5, 2.5, 3.5, 4.5])
    assert_equal(t.send(:initialize), nil)
    assert_equal(fields(t), [1.5, 2.5, 3.5, 4.5])
  end

  def test_typechecking
    t = Tone.new
    t.set(Color.new(1.5, 2.5, 3.5, 4.5))
    assert_equal(fields(t), [1.5, 2.5, 3.5, 4.5])
    assert_raise_with_message(TypeError, "wrong argument type Object (expected Data)") { t.set(Object.new) }
  end

  def test_argchecking
    assert_raise_with_message(ArgumentError, "wrong number of arguments (3 for 1)") { Tone.new(1.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (3 for 2)") { Tone.new(1.5, 2.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 5)") { Tone.new(1.5, 2.5, 3.5, 4.5, 5.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (3 for 2)") { Tone.new.set(1.5, 2.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 5)") { Tone.new.set(1.5, 2.5, 3.5, 4.5, 5.5) }
  end
end

run_test(TestTone)
