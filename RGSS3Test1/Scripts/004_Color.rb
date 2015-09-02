class TestColor

  class BareColor < Color
    def initialize; end
  end

  def test_class
    assert_equal(Color.superclass, Object)
  end

  def fields(c)
    [c.red, c.green, c.blue, c.alpha]
  end

  def test_constructor
    assert_equal(fields(Color.new(1.5, 2.5, 3.5, 4.5)), [1.5, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, 3.5)), [1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new), [0.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new(1, 2, 3, 4)), [1.0, 2.0, 3.0, 4.0])
    assert_equal(fields(Color.new(1, 2, 3)), [1.0, 2.0, 3.0, 255.0])
    assert_raise(ArgumentError) { Color.new(1.5) }
    assert_raise(ArgumentError) { Color.new(1.5, 2.5) }
    assert_raise(ArgumentError) { Color.new(1.5, 2.5, 3.5, 4.5, 5.5) }
    assert_raise(TypeError) { Color.new("1.5", 2.5, 3.5, 4.5) }
    assert_raise(TypeError) { Color.new(1.5, "2.5", 3.5, 4.5) }
    assert_raise(TypeError) { Color.new(1.5, 2.5, "3.5", 4.5) }
    assert_raise(TypeError) { Color.new(1.5, 2.5, 3.5, "4.5") }
    assert_raise(TypeError) { Color.new("1.5", 2.5, 3.5) }
    assert_raise(TypeError) { Color.new(1.5, "2.5", 3.5) }
    assert_raise(TypeError) { Color.new(1.5, 2.5, "3.5") }
    assert(Float === Color.new(1, 2, 3, 4).red)
    assert(Float === Color.new(1, 2, 3, 4).green)
    assert(Float === Color.new(1, 2, 3, 4).blue)
    assert(Float === Color.new(1, 2, 3, 4).alpha)
    assert(Float === Color.new(1, 2, 3).red)
    assert(Float === Color.new(1, 2, 3).green)
    assert(Float === Color.new(1, 2, 3).blue)
    assert(Float === Color.new(1, 2, 3).alpha)
  end

  def test_constructor_saturation_lb
    # Constructor saturates toward 0.0
    # RGSS BUG: it doesn't saturate R/G/B actually.
    # assert_equal(fields(Color.new(-1.5, 2.5, 3.5, 4.5)), [0.0, 2.5, 3.5, 4.5])
    # assert_equal(fields(Color.new(1.5, -2.5, 3.5, 4.5)), [1.5, 0.0, 3.5, 4.5])
    # assert_equal(fields(Color.new(1.5, 2.5, -3.5, 4.5)), [1.5, 2.5, 0.0, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    # assert_equal(fields(Color.new(-1.5, 2.5, 3.5)), [0.0, 2.5, 3.5, 255.0])
    # assert_equal(fields(Color.new(1.5, -2.5, 3.5)), [1.5, 0.0, 3.5, 255.0])
    # assert_equal(fields(Color.new(1.5, 2.5, -3.5)), [1.5, 2.5, 0.0, 255.0])
  end

  def test_constructor_saturation_ub
    # Constructor saturates toward 255.0
    assert_equal(fields(Color.new(301.5, 2.5, 3.5, 4.5)), [255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, 302.5, 3.5, 4.5)), [1.5, 255.0, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, 303.5, 4.5)), [1.5, 2.5, 255.0, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, 3.5, 304.5)), [1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new(301.5, 2.5, 3.5)), [255.0, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, 302.5, 3.5)), [1.5, 255.0, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, 2.5, 303.5)), [1.5, 2.5, 255.0, 255.0])
  end

  def test_equality
    # Color is equal when red, green, blue and alpha is equal.
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 4.5), 1)
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 4.5), "foo")
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 4.5), [1])
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 4.5), :foo)
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 4.5), Object.new)
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 4.5), Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Color.new(11.5, 2.5, 3.5, 4.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Color.new(1.5, 12.5, 3.5, 4.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Color.new(1.5, 2.5, 13.5, 4.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_not_equal(Color.new(1.5, 2.5, 3.5, 14.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_not_same(Color.new(1.5, 2.5, 3.5, 4.5), Color.new(1.5, 2.5, 3.5, 4.5))
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5) <=> Color.new(1.5, 2.5, 3.5, 4.5), 0)
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5) <=> Color.new(1.5, 2.5, 3.5, 14.5), nil)
  end

  def test_set
    c = Color.new
    assert_same(c, c.set)
    assert_same(c, c.set(Color.new))
    assert_same(c, c.set(1.5, 2.5, 3.5))
    assert_same(c, c.set(1.5, 2.5, 3.5, 4.5))

    assert_equal(fields(Color.new.set(1.5, 2.5, 3.5, 4.5)), [1.5, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, 3.5)), [1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, 2.5, 3.5, 4.5).set), [0.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new.set(Color.new(1.5, 2.5, 3.5, 4.5))),
                 [1.5, 2.5, 3.5, 4.5])
    assert_raise(ArgumentError) { Color.new.set(1.5, 2.5) }
    assert_raise(ArgumentError) { Color.new.set(1.5, 2.5, 3.5, 4.5, 5.5) }
    assert_raise(TypeError) { Color.new.set("1.5", 2.5, 3.5, 4.5) }
    assert_raise(TypeError) { Color.new.set(1.5, "2.5", 3.5, 4.5) }
    assert_raise(TypeError) { Color.new.set(1.5, 2.5, "3.5", 4.5) }
    assert_raise(TypeError) { Color.new.set(1.5, 2.5, 3.5, "4.5") }
    assert_raise(TypeError) { Color.new.set("1.5", 2.5, 3.5) }
    assert_raise(TypeError) { Color.new.set(1.5, "2.5", 3.5) }
    assert_raise(TypeError) { Color.new.set(1.5, 2.5, "3.5") }
    assert_raise(TypeError) { Color.new.set(1.5) }
    assert(Float === Color.new.set(1, 2, 3, 4).red)
    assert(Float === Color.new.set(1, 2, 3, 4).green)
    assert(Float === Color.new.set(1, 2, 3, 4).blue)
    assert(Float === Color.new.set(1, 2, 3, 4).alpha)
    assert(Float === Color.new.set(1, 2, 3).red)
    assert(Float === Color.new.set(1, 2, 3).green)
    assert(Float === Color.new.set(1, 2, 3).blue)
    assert(Float === Color.new.set(1, 2, 3).alpha)

    c1 = Color.new
    c2 = Color.new(1.5, 2.5, 3.5, 4.5)
    c1.set(c2)
    c1.red = 11.5
    assert_equal(c2.red, 1.5)
    c2.green = 12.5
    assert_equal(c1.green, 2.5)
  end

  def test_set_saturation_lb
    # Setters saturate toward 0.0.
    # RGSS BUG: it doesn't saturate R/G/B actually.
    # assert_equal(fields(Color.new.set(-1.5, 2.5, 3.5, 4.5)), [0.0, 2.5, 3.5, 4.5])
    # assert_equal(fields(Color.new.set(1.5, -2.5, 3.5, 4.5)), [1.5, 0.0, 3.5, 4.5])
    # assert_equal(fields(Color.new.set(1.5, 2.5, -3.5, 4.5)), [1.5, 2.5, 0.0, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    # assert_equal(fields(Color.new.set(-1.5, 2.5, 3.5)), [0.0, 2.5, 3.5, 255.0])
    # assert_equal(fields(Color.new.set(1.5, -2.5, 3.5)), [1.5, 0.0, 3.5, 255.0])
    # assert_equal(fields(Color.new.set(1.5, 2.5, -3.5)), [1.5, 2.5, 0.0, 255.0])
  end

  def test_set_saturation_ub
    # Setters saturate toward 255.0
    assert_equal(fields(Color.new.set(301.5, 2.5, 3.5, 4.5)), [255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, 302.5, 3.5, 4.5)), [1.5, 255.0, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, 303.5, 4.5)), [1.5, 2.5, 255.0, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, 3.5, 304.5)), [1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new.set(301.5, 2.5, 3.5)), [255.0, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new.set(1.5, 302.5, 3.5)), [1.5, 255.0, 3.5, 255.0])
    assert_equal(fields(Color.new.set(1.5, 2.5, 303.5)), [1.5, 2.5, 255.0, 255.0])
  end

  def test_getters
    # Getters
    assert_raise(ArgumentError) { Color.new.red(1.5) }
    assert_raise(ArgumentError) { Color.new.green(1.5) }
    assert_raise(ArgumentError) { Color.new.blue(1.5) }
    assert_raise(ArgumentError) { Color.new.alpha(1.5) }
  end

  def test_setters
    # Setters return the argument.
    c = Color.new
    assert_equal(1.5, c.red = 1.5)
    assert_equal(2.5, c.green = 2.5)
    assert_equal(3.5, c.blue = 3.5)
    assert_equal(4.5, c.alpha = 4.5)
    assert(Integer === (c.red = 1))
    assert(Integer === (c.green = 2))
    assert(Integer === (c.blue = 3))
    assert(Integer === (c.alpha = 4))

    # Setters
    assert_equal(fields(Color.new.tap{|c|c.red = 1.5}), [1.5, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.green = 2.5}), [0.0, 2.5, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.blue = 3.5}), [0.0, 0.0, 3.5, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.alpha = 4.5}), [0.0, 0.0, 0.0, 4.5])
  end

  def test_setters_saturation_lb
    # Setters saturate toward 0.0
    # RGSS BUG: it doesn't saturate R/G/B actually.
    # assert_equal(fields(Color.new.tap{|c|c.red = -1.5}), [0.0, 0.0, 0.0, 0.0])
    # assert_equal(fields(Color.new.tap{|c|c.green = -2.5}), [0.0, 0.0, 0.0, 0.0])
    # assert_equal(fields(Color.new.tap{|c|c.blue = -3.5}), [0.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.alpha = -4.5}), [0.0, 0.0, 0.0, 0.0])
  end

  def test_setters_saturation_ub
    # Setters saturate toward 255.0
    assert_equal(fields(Color.new.tap{|c|c.red = 301.5}), [255.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.green = 302.5}), [0.0, 255.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.blue = 303.5}), [0.0, 0.0, 255.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.alpha = 304.5}), [0.0, 0.0, 0.0, 255.0])
  end

  def test_to_s
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5).to_s,
                 "(1.500000, 2.500000, 3.500000, 4.500000)")
    assert_equal(Color.new(201.5, 202.5, 203.5, 204.5).to_s,
                 "(201.500000, 202.500000, 203.500000, 204.500000)")
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5).inspect,
                 "(1.500000, 2.500000, 3.500000, 4.500000)")
    assert_equal(Color.new(201.5, 202.5, 203.5, 204.5).inspect,
                 "(201.500000, 202.500000, 203.500000, 204.500000)")
  end

  def test_initialize_copy
    # initialize_copy is private
    assert_raise(NoMethodError) {Color.new.initialize_copy}

    # initialize_copy behaves like set.
    assert_equal(
      fields(Color.new.tap{|c|c.send(:initialize_copy,
                                     Color.new(1.5, 2.5, 3.5, 4.5))}),
      [1.5, 2.5, 3.5, 4.5])
  end

  def test_load
    # _load
    assert_equal(fields(Color._load([1.5, 2.5, 3.5, 4.5].pack('E*'))),
                 [1.5, 2.5, 3.5, 4.5])
  end

  def test_dump
    # _dump
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5)._dump(1),
                 [1.5, 2.5, 3.5, 4.5].pack('E*'))
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5)._dump(0),
                 [1.5, 2.5, 3.5, 4.5].pack('E*'))
    assert_equal(Color.new(1.5, 2.5, 3.5, 4.5)._dump(-1),
                 [1.5, 2.5, 3.5, 4.5].pack('E*'))
  end

  def test_load_saturation_buggy
    assert_equal(fields(Color._load([-1.5, -2.5, -3.5, -4.5].pack('E*'))),
                 [-1.5, -2.5, -3.5, -4.5])
    assert_equal(fields(Color._load([301.5, 302.5, 303.5, 304.5].pack('E*'))),
                 [301.5, 302.5, 303.5, 304.5])
  end

  def test_freeze_buggy
    # Freeze [BUGGY BEHAVIOR]
    c = Color.new
    c.freeze
    assert(c.frozen?)
    c.red = 1.5
    c.green = 2.5
    c.blue = 3.5
    c.alpha = 4.5
    assert_equal(fields(c), [1.5, 2.5, 3.5, 4.5])
    c.set(11.5, 12.5, 13.5, 14.5)
    assert_equal(fields(c), [11.5, 12.5, 13.5, 14.5])
    c.set(21.5, 22.5, 23.5)
    assert_equal(fields(c), [21.5, 22.5, 23.5, 255.0])
    c.set(Color.new(31.5, 32.5, 33.5, 34.5))
    assert_equal(fields(c), [31.5, 32.5, 33.5, 34.5])
    c.set
    assert_equal(fields(c), [0.0, 0.0, 0.0, 0.0])
  end

  def test_constructor_saturation_lb_buggy
    # Constructor saturates toward 0.0 [BUGGY BEHAVIOR]
    assert_equal(fields(Color.new(-1.5, 2.5, 3.5, 4.5)), [-1.5, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, -2.5, 3.5, 4.5)), [1.5, -2.5, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, -3.5, 4.5)), [1.5, 2.5, -3.5, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Color.new(-1.5, 2.5, 3.5)), [-1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, -2.5, 3.5)), [1.5, -2.5, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, 2.5, -3.5)), [1.5, 2.5, -3.5, 255.0])

    assert_equal(fields(Color.new(-301.5, 2.5, 3.5, 4.5)), [-255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, -302.5, 3.5, 4.5)), [1.5, -255.0, 3.5, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, -303.5, 4.5)), [1.5, 2.5, -255.0, 4.5])
    assert_equal(fields(Color.new(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Color.new(-301.5, 2.5, 3.5)), [-255.0, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, -302.5, 3.5)), [1.5, -255.0, 3.5, 255.0])
    assert_equal(fields(Color.new(1.5, 2.5, -303.5)), [1.5, 2.5, -255.0, 255.0])
  end

  def test_set_saturation_lb_buggy
    # Setters saturate toward 0.0 [BUGGY BEHAVIOR]
    assert_equal(fields(Color.new.set(-1.5, 2.5, 3.5, 4.5)), [-1.5, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, -2.5, 3.5, 4.5)), [1.5, -2.5, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, -3.5, 4.5)), [1.5, 2.5, -3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Color.new.set(-1.5, 2.5, 3.5)), [-1.5, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new.set(1.5, -2.5, 3.5)), [1.5, -2.5, 3.5, 255.0])
    assert_equal(fields(Color.new.set(1.5, 2.5, -3.5)), [1.5, 2.5, -3.5, 255.0])

    assert_equal(fields(Color.new.set(-301.5, 2.5, 3.5, 4.5)), [-255.0, 2.5, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, -302.5, 3.5, 4.5)), [1.5, -255.0, 3.5, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, -303.5, 4.5)), [1.5, 2.5, -255.0, 4.5])
    assert_equal(fields(Color.new.set(1.5, 2.5, 3.5, -4.5)), [1.5, 2.5, 3.5, 0.0])
    assert_equal(fields(Color.new.set(-301.5, 2.5, 3.5)), [-255.0, 2.5, 3.5, 255.0])
    assert_equal(fields(Color.new.set(1.5, -302.5, 3.5)), [1.5, -255.0, 3.5, 255.0])
    assert_equal(fields(Color.new.set(1.5, 2.5, -303.5)), [1.5, 2.5, -255.0, 255.0])
  end

  def test_setters_saturation_lb_buggy
    # Setters saturate toward 0.0 [BUGGY BEHAVIOR]
    assert_equal(fields(Color.new.tap{|c|c.red = -1.5}), [-1.5, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.green = -2.5}), [0.0, -2.5, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.blue = -3.5}), [0.0, 0.0, -3.5, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.alpha = -4.5}), [0.0, 0.0, 0.0, 0.0])

    assert_equal(fields(Color.new.tap{|c|c.red = -301.5}), [-255.0, 0.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.green = -302.5}), [0.0, -255.0, 0.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.blue = -303.5}), [0.0, 0.0, -255.0, 0.0])
    assert_equal(fields(Color.new.tap{|c|c.alpha = -4.5}), [0.0, 0.0, 0.0, 0.0])
  end

  def construct_load(red, green, blue, alpha)
    Color._load([red, green, blue, alpha].pack('E*'))
  end

  def test_cloning_saturation_buggy
    assert_equal(
      fields(Color.new.tap{|c|c.set(construct_load(-1.5, -2.5, -3.5, -4.5))}),
      [-1.5, -2.5, -3.5, -4.5])
    assert_equal(
      fields(
        Color.new.tap{|c|c.set(construct_load(301.5, 302.5, 303.5, 304.5))}),
      [301.5, 302.5, 303.5, 304.5])
    assert_equal(
      fields(
        Color.new.tap{|c|c.send(:initialize_copy,
                                construct_load(-1.5, -2.5, -3.5, -4.5))}),
      [-1.5, -2.5, -3.5, -4.5])
    assert_equal(
      fields(
        Color.new.tap{|c|c.send(:initialize_copy,
                                construct_load(301.5, 302.5, 303.5, 304.5))}),
      [301.5, 302.5, 303.5, 304.5])
  end

  def test_allocator
    assert(fields(BareColor.new) == [0.0, 0.0, 0.0, 0.0])
    c = BareColor.new
    c.set(1.5, 2.5, 3.5, 4.5)
    assert_equal(fields(c), [1.5, 2.5, 3.5, 4.5])
    assert_equal(c.send(:initialize), nil)
    assert_equal(fields(c), [1.5, 2.5, 3.5, 4.5])
  end

  def test_typechecking
    c = Color.new
    c.set(Tone.new(1.5, 2.5, 3.5, 4.5))
    assert_equal(fields(c), [1.5, 2.5, 3.5, 4.5])
    assert_raise_with_message(TypeError, "wrong argument type Object (expected Data)") { c.set(Object.new) }
  end

  def test_argchecking
    assert_raise_with_message(ArgumentError, "wrong number of arguments (3 for 1)") { Color.new(1.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (3 for 2)") { Color.new(1.5, 2.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 5)") { Color.new(1.5, 2.5, 3.5, 4.5, 5.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (3 for 2)") { Color.new.set(1.5, 2.5) }
    assert_raise_with_message(ArgumentError, "wrong number of arguments (4 for 5)") { Color.new.set(1.5, 2.5, 3.5, 4.5, 5.5) }
  end
end

run_test(TestColor)
