class TestFont

  def initialize
    @default_name = Font.default_name
    @default_size = Font.default_size
    @default_bold = Font.default_bold
    @default_italic = Font.default_italic
    @default_shadow = Font.default_shadow
    @default_outline = Font.default_outline
    @default_color = Font.default_color
    @default_out_color = Font.default_out_color
  end

  def restore_default
    Font.default_name = @default_name
    Font.default_size = @default_size
    Font.default_bold = @default_bold
    Font.default_italic = @default_italic
    Font.default_shadow = @default_shadow
    Font.default_outline = @default_outline
    Font.default_color = @default_color
    Font.default_out_color = @default_out_color
  end

  def test_class
    assert_equal(Font.superclass, Object)
  end

  def compare_default(f, name = Font.default_name, size = Font.default_size)
    assert_same(f.name, name)
    assert_equal(f.size, size)
    assert_equal(f.bold, Font.default_bold)
    assert_equal(f.italic, Font.default_italic)
    assert_equal(f.shadow, Font.default_shadow)
    assert_equal(f.outline, Font.default_outline)
    assert_equal(f.color, Font.default_color)
    assert_equal(f.out_color, Font.default_out_color)
    assert_not_same(f.color, Font.default_color)
    assert_not_same(f.out_color, Font.default_out_color)
  end

  def test_constructor
    compare_default(Font.new)
    o = Object.new
    compare_default(Font.new(o), o)
    o = Object.new
    s = Object.new
    def s.to_int; 50; end
    compare_default(Font.new(o, s), o, s)
    assert_raise(ArgumentError) { Font.new("VL Gothic", 30, 20) }
    assert_raise(TypeError) { Font.new("VL Gothic", "5") }
    Font.new("VL Gothic", 6)
    Font.new("VL Gothic", 6.5)
    assert_raise(ArgumentError) { Font.new("VL Gothic", 5) }
    assert_raise(ArgumentError) { Font.new("VL Gothic", 5.5) }
    assert_raise(ArgumentError) { Font.new("VL Gothic", -10) }
    Font.new("VL Gothic", 96)
    Font.new("VL Gothic", 96.5)
    assert_raise(ArgumentError) { Font.new("VL Gothic", 97) }
    assert_raise(ArgumentError) { Font.new("VL Gothic", 97.5) }
    assert_raise(RangeError) { Font.new("VL Gothic", Float::NAN) }
    assert_raise(RangeError) { Font.new("VL Gothic", (1<<31)) }
    assert_raise(RangeError) { Font.new("VL Gothic", -(1<<31)-1) }
  end

  def test_getters
    f = Font.new
    assert_raise(ArgumentError) { f.name(1) }
    assert_raise(ArgumentError) { f.size(1) }
    assert_raise(ArgumentError) { f.bold(1) }
    assert_raise(ArgumentError) { f.italic(1) }
    assert_raise(ArgumentError) { f.outline(1) }
    assert_raise(ArgumentError) { f.shadow(1) }
    assert_raise(ArgumentError) { f.color(1) }
    assert_raise(ArgumentError) { f.out_color(1) }
    assert_raise(ArgumentError) { Font.default_name(1) }
    assert_raise(ArgumentError) { Font.default_size(1) }
    assert_raise(ArgumentError) { Font.default_bold(1) }
    assert_raise(ArgumentError) { Font.default_italic(1) }
    assert_raise(ArgumentError) { Font.default_outline(1) }
    assert_raise(ArgumentError) { Font.default_shadow(1) }
    assert_raise(ArgumentError) { Font.default_color(1) }
    assert_raise(ArgumentError) { Font.default_out_color(1) }

    o = Object.new
    Font.class_variable_set(:@@default_name, o)
    assert_same(Font.default_name, o)
    o = Object.new
    Font.class_variable_set(:@@default_size, o)
    assert_same(Font.default_size, o)
    o = Object.new
    Font.class_variable_set(:@@default_bold, o)
    assert_same(Font.default_bold, o)
    o = Object.new
    Font.class_variable_set(:@@default_italic, o)
    assert_same(Font.default_italic, o)
    o = Object.new
    Font.class_variable_set(:@@default_outline, o)
    assert_same(Font.default_outline, o)
    o = Object.new
    Font.class_variable_set(:@@default_shadow, o)
    assert_same(Font.default_shadow, o)
    o = Object.new
    Font.class_variable_set(:@@default_color, o)
    assert_same(Font.default_color, o)
    o = Object.new
    Font.class_variable_set(:@@default_out_color, o)
    assert_same(Font.default_out_color, o)
    restore_default
  ensure
    restore_default
  end

  def test_setters
    f = Font.new
    o = Object.new
    s = Object.new
    def s.to_int; 50; end
    assert_same(f.name = o, o)
    assert_equal(f.size = s, s)
    assert_equal(f.bold = true, true)
    assert_equal(f.italic = true, true)
    assert_equal(f.outline = false, false)
    assert_equal(f.shadow = true, true)
    c = Color.new(1.5, 2.5, 3.5, 4.5)
    assert_same(f.color = c, c)
    assert_equal(f.color, c)
    assert_not_same(f.color, c)
    c = Color.new(11.5, 12.5, 13.5, 14.5)
    assert_same(f.out_color = c, c)
    assert_equal(f.out_color, c)
    assert_not_same(f.out_color, c)
    o = Object.new
    s = Object.new
    def s.to_int; 50; end
    assert_equal(Font.default_name = o, o)
    assert_equal(Font.default_size = s, s)
    assert_equal(Font.default_bold = true, true)
    assert_equal(Font.default_italic = true, true)
    assert_equal(Font.default_outline = false, false)
    assert_equal(Font.default_shadow = true, true)
    c = Color.new(1.5, 2.5, 3.5, 4.5)
    assert_same(Font.default_color = c, c)
    assert_equal(Font.default_color, c)
    # assert_not_same(Font.default_color, c)
    assert_same(Font.default_color, c)
    c = Color.new(11.5, 12.5, 13.5, 14.5)
    assert_same(Font.default_out_color = c, c)
    assert_equal(Font.default_out_color, c)
    # assert_not_same(Font.default_out_color, c)
    assert_same(Font.default_out_color, c)
    restore_default

    f = Font.new
    f.size = 6
    f.size = 6.5
    assert_raise(ArgumentError) { f.size = 5 }
    assert_raise(ArgumentError) { f.size = 5.5 }
    assert_raise(ArgumentError) { f.size = -10 }
    f.size = 96
    f.size = 96.5
    assert_raise(ArgumentError) { f.size = 97 }
    assert_raise(ArgumentError) { f.size = 97.5 }
    assert_raise(RangeError) { f.size = Float::NAN }
    assert_raise(RangeError) { f.size = (1<<31) }
    assert_raise(RangeError) { f.size = -(1<<31)-1 }
    Font.default_size = 6
    Font.default_size = 6.5
    assert_raise(ArgumentError) { Font.default_size = 5 }
    assert_raise(ArgumentError) { Font.default_size = 5.5 }
    assert_raise(ArgumentError) { Font.default_size = -10 }
    Font.default_size = 96
    Font.default_size = 96.5
    assert_raise(ArgumentError) { Font.default_size = 97 }
    assert_raise(ArgumentError) { Font.default_size = 97.5 }
    assert_raise(RangeError) { Font.default_size = Float::NAN }
    assert_raise(RangeError) { Font.default_size = (1<<31) }
    assert_raise(RangeError) { Font.default_size = -(1<<31)-1 }
    restore_default

    f = Font.new
    assert(NilClass === (f.bold = nil))
    assert(FalseClass === f.bold)
    assert(Integer === (f.bold = 0))
    assert(TrueClass === f.bold)
    assert(NilClass === (f.italic = nil))
    assert(FalseClass === f.italic)
    assert(Integer === (f.italic = 0))
    assert(TrueClass === f.italic)
    assert(NilClass === (f.shadow = nil))
    assert(FalseClass === f.shadow)
    assert(Integer === (f.shadow = 0))
    assert(TrueClass === f.shadow)
    assert(NilClass === (f.outline = nil))
    assert(FalseClass === f.outline)
    assert(Integer === (f.outline = 0))
    assert(TrueClass === f.outline)
    assert_raise(TypeError) { f.color = Object.new }
    assert_raise(TypeError) { f.out_color = Object.new }
    assert(NilClass === (Font.default_bold = nil))
    assert(NilClass === Font.default_bold)
    assert(Integer === (Font.default_bold = 0))
    assert(Integer === Font.default_bold)
    assert(NilClass === (Font.default_italic = nil))
    assert(NilClass === Font.default_italic)
    assert(Integer === (Font.default_italic = 0))
    assert(Integer === Font.default_italic)
    assert(NilClass === (Font.default_shadow = nil))
    assert(NilClass === Font.default_shadow)
    assert(Integer === (Font.default_shadow = 0))
    assert(Integer === Font.default_shadow)
    assert(NilClass === (Font.default_outline = nil))
    assert(NilClass === Font.default_outline)
    assert(Integer === (Font.default_outline = 0))
    assert(Integer === Font.default_outline)
    assert_raise(TypeError) { Font.default_color = Object.new }
    assert_raise(TypeError) { Font.default_out_color = Object.new }
    restore_default

    o = Object.new
    Font.default_name = o
    assert_same(Font.class_variable_get(:@@default_name), o)
    o = Object.new
    def o.to_int; 50; end
    Font.default_size = o
    assert_same(Font.class_variable_get(:@@default_size), o)
    o = Object.new
    Font.default_bold = o
    assert_same(Font.class_variable_get(:@@default_bold), o)
    o = Object.new
    Font.default_italic = o
    assert_same(Font.class_variable_get(:@@default_italic), o)
    o = Object.new
    Font.default_shadow = o
    assert_same(Font.class_variable_get(:@@default_shadow), o)
    o = Object.new
    Font.default_outline = o
    assert_same(Font.class_variable_get(:@@default_outline), o)
    c = Color.new(1.5, 2.5, 3.5, 4.5)
    Font.default_color = c
    assert_same(Font.class_variable_get(:@@default_color), c)
    c = Color.new(11.5, 12.5, 13.5, 14.5)
    Font.default_out_color = c
    assert_same(Font.class_variable_get(:@@default_out_color), c)
    restore_default
  ensure
    restore_default
  end

  def test_exist_p
    assert_raise(ArgumentError) { Font.exist? }
    assert_raise(ArgumentError) { Font.exist?("VL Gothic", "VL Gothic") }
    assert_equal(Font.exist?(5), false)
    assert_equal(Font.exist?("VL Gothic"), true)
    assert_equal(Font.exist?(["VL Gothic"]), false)
    o = Object.new
    def o.to_s; "VL Gothic"; end
    assert_equal(Font.exist?(o), true)
  end
end

run_test(TestFont)
