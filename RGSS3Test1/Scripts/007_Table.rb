class TestTable

  def test_class
    assert_equal(Table.superclass, Object)
  end

  def genraw(dim, xsize, ysize, zsize, size, data)
    [dim, xsize, ysize, zsize, size, *data].pack("VVVVVv*")
  end

  def rawheader(t)
    h = t._dump(1).unpack("VVVVVv*")[0..4]
    5.times do|i|
      h[i] -= (1<<32) if h[i] >= (1<<31)
    end
    h
  end

  def rawdata(t)
    d = t._dump(1).unpack("VVVVVv*")
    d = [*d[0...5], d[5..-1]]
    5.times do|i|
      d[i] -= (1<<32) if d[i] >= (1<<31)
    end
    d[5].size.times do|i|
      d[5][i] -= (1<<16) if d[5][i] >= (1<<15)
    end
    d
  end

  def sizes(t)
    [t.xsize, t.ysize, t.zsize]
  end

  def test_constructor
    assert_equal(sizes(Table.new(10)), [10, 1, 1])
    assert_equal(sizes(Table.new(10, 20)), [10, 20, 1])
    assert_equal(sizes(Table.new(10, 20, 30)), [10, 20, 30])
    assert_equal(sizes(Table.new(0)), [0, 1, 1])
    assert_equal(sizes(Table.new(-10)), [0, 1, 1])
    assert_equal(sizes(Table.new(0, 20)), [0, 20, 1])
    assert_equal(sizes(Table.new(-10, 20)), [0, 20, 1])
    assert_equal(sizes(Table.new(10, 0)), [10, 0, 1])
    assert_equal(sizes(Table.new(10, -20)), [10, 0, 1])
    assert_equal(sizes(Table.new(0, 20, 30)), [0, 20, 30])
    assert_equal(sizes(Table.new(-10, 20, 30)), [0, 20, 30])
    assert_equal(sizes(Table.new(10, 0, 30)), [10, 0, 30])
    assert_equal(sizes(Table.new(10, -20, 30)), [10, 0, 30])
    assert_equal(sizes(Table.new(10, 20, 0)), [10, 20, 0])
    assert_equal(sizes(Table.new(10, 20, -30)), [10, 20, 0])
    assert_equal(sizes(Table.new(10.5)), [10, 1, 1])
    assert_equal(sizes(Table.new(10.5, 20.5)), [10, 20, 1])
    assert_equal(sizes(Table.new(10.5, 20.5, 30.5)), [10, 20, 30])
    assert_equal(rawheader(Table.new(10)), [1, 10, 1, 1, 10])
    assert_equal(rawheader(Table.new(10, 20)), [2, 10, 20, 1, 200])
    assert_equal(rawheader(Table.new(10, 20, 30)), [3, 10, 20, 30, 6000])
    assert_equal(rawheader(Table.new(-10)), [1, 0, 1, 1, 0])
    assert_equal(rawheader(Table.new(-10, 20)), [2, 0, 20, 1, 0])
    assert_equal(rawheader(Table.new(10, -20)), [2, 10, 0, 1, 0])
    assert_equal(rawheader(Table.new(-10, 20, 30)), [3, 0, 20, 30, 0])
    assert_equal(rawheader(Table.new(10, -20, 30)), [3, 10, 0, 30, 0])
    assert_equal(rawheader(Table.new(10, 20, -30)), [3, 10, 20, 0, 0])
    assert_raise(ArgumentError) { Table.new }
    assert_raise(ArgumentError) { Table.new(10, 20, 30, 40) }
    assert_raise(TypeError) { Table.new("10") }
    assert_raise(TypeError) { Table.new("10", 20) }
    assert_raise(TypeError) { Table.new(10, "20") }
    assert_raise(TypeError) { Table.new("10", 20, 30) }
    assert_raise(TypeError) { Table.new(10, "20", 30) }
    assert_raise(TypeError) { Table.new(10, 20, "30") }
    assert(Integer === Table.new(10.5).xsize)
    assert(Integer === Table.new(10.5, 20.5).xsize)
    assert(Integer === Table.new(10.5, 20.5).ysize)
    assert(Integer === Table.new(10.5, 20.5, 30.5).xsize)
    assert(Integer === Table.new(10.5, 20.5, 30.5).ysize)
    assert(Integer === Table.new(10.5, 20.5, 30.5).zsize)
  end

  def test_equality
    t1 = Table.new(10, 20, 30)
    t2 = Table.new(10, 20, 30)
    t3 = Table.new(10, 20, 30)
    t1[4, 19, 11] = t2[4, 19, 11] = t3[4, 19, 11] = 5
    t1[5, 10, 1] = t2[5, 10, 1] = -3
    t3[5, 10, 1] = -4
    assert_not_equal(t1, t2)
    assert_not_equal(t1, t3)
    assert_not_same(t1, t2)
    assert_not_same(t1, t3)
  end

  def test_getters
    t = Table.new(10, 20, 30)
    t[4, 19, 11] = 5
    t[5, 10, 1] = -3
    assert_equal(t[3, 18, 10], 0)
    assert_equal(t[4, 19, 11], 5)
    assert_equal(t[4.5, 19.5, 11.5], 5)
    assert_equal(t[-1, 19, 11], nil)
    assert_equal(t[4, -1, 11], nil)
    assert_equal(t[4, 19, -1], nil)
    assert_equal(t[10, 19, 11], nil)
    assert_equal(t[4, 20, 11], nil)
    assert_equal(t[4, 19, 30], nil)
    assert_raise(ArgumentError) { t[4, 19, 11, 99] }
    assert_raise(ArgumentError) { t[4, 19] }
    assert_raise(ArgumentError) { t[4] }
    assert_raise(TypeError) { t["4", 19, 11] }
    assert_raise(TypeError) { t[4, "19", 11] }
    assert_raise(TypeError) { t[4, 19, "11"] }

    t = Table.new(10, 20)
    t[4, 19] = 5
    t[5, 10] = -3
    assert_equal(t[3, 18], 0)
    assert_equal(t[4, 19], 5)
    assert_equal(t[4.5, 19.5], 5)
    assert_equal(t[-1, 19], nil)
    assert_equal(t[4, -1], nil)
    assert_equal(t[10, 19], nil)
    assert_equal(t[4, 20], nil)
    assert_raise(ArgumentError) { t[4, 19, 11, 99] }
    assert_raise(ArgumentError) { t[4, 19, 11] }
    assert_raise(ArgumentError) { t[4] }
    assert_raise(ArgumentError) { t[] }
    assert_raise(TypeError) { t["4", 19] }
    assert_raise(TypeError) { t[4, "19"] }

    t = Table.new(10)
    t[4] = 5
    t[5] = -3
    assert_equal(t[3], 0)
    assert_equal(t[4], 5)
    assert_equal(t[4.5], 5)
    assert_equal(t[-1], nil)
    assert_equal(t[10], nil)
    assert_raise(ArgumentError) { t[4, 19, 11, 99] }
    assert_raise(ArgumentError) { t[4, 19, 11] }
    assert_raise(ArgumentError) { t[4, 19] }
    assert_raise(ArgumentError) { t[] }
    assert_raise(TypeError) { t["4"] }
  end

  def test_setters
    t = Table.new(10, 20, 30)
    assert_equal(t[4, 19, 11] = 5, 5)
    assert_equal(t[-1, -1, -1] = 5, 5)
    assert(Float === (t[4, 19, 11] = 10.5))
    assert_raise(ArgumentError) { t[4, 19, 11, 99] = 5 }
    # assert_raise(ArgumentError) { t[4, 19] = 5 }
    assert_raise(ArgumentError) { t[4] = 5 }
    assert_raise(ArgumentError) { t[] = 5 }
    assert_raise(TypeError) { t["4", 19, 11] = 5 }
    assert_raise(TypeError) { t[4, "19", 11] = 5 }
    assert_raise(TypeError) { t[4, 19, "11"] = 5 }
    assert_raise(TypeError) { t[4, 19, 11] = "5" }
    t = Table.new(10, 20, 30)
    t[-1, 19, 11] = 5
    t[4, -1, 11] = 5
    t[4, 19, -1] = 5
    t[10, 19, 11] = 5
    t[4, 20, 11] = 5
    t[4, 19, 30] = 5
    assert((0...10).all? {|x| (0...20).all? {|y| (0...30).all? {|z| t[x, y, z] == 0}}})

    t = Table.new(10, 20)
    assert_equal(t[4, 19] = 5, 5)
    assert_equal(t[-1, -1] = 5, 5)
    assert(Float === (t[4, 19] = 10.5))
    assert_raise(ArgumentError) { t[4, 19, 11, 99] = 5 }
    assert_raise(ArgumentError) { t[4, 19, 11] = 5 }
    # assert_raise(ArgumentError) { t[4] = 5 }
    assert_raise(ArgumentError) { t[] = 5 }
    assert_raise(TypeError) { t["4", 19] = 5 }
    assert_raise(TypeError) { t[4, "19"] = 5 }
    assert_raise(TypeError) { t[4, 19] = "5" }
    t = Table.new(10, 20)
    t[-1, 19] = 5
    t[4, -1] = 5
    t[10, 19] = 5
    t[4, 20] = 5
    assert((0...10).all? {|x| (0...20).all? {|y| t[x, y] == 0}})

    t = Table.new(10)
    assert_equal(t[4] = 5, 5)
    assert_equal(t[-1] = 5, 5)
    assert(Float === (t[4] = 10.5))
    assert_raise(ArgumentError) { t[4, 19, 11, 99] = 5 }
    assert_raise(ArgumentError) { t[4, 19, 11] = 5 }
    assert_raise(ArgumentError) { t[4, 19] = 5 }
    # assert_raise(ArgumentError) { t[] = 5 }
    assert_raise(TypeError) { t["4"] = 5 }
    assert_raise(TypeError) { t[4] = "5" }
    t = Table.new(10)
    t[-1] = 5
    t[10] = 5
    assert((0...10).all? {|x| t[x] == 0})
  end

  def test_initialize_copy
    # initialize_copy is private
    assert_raise(NoMethodError) {Table.new(10, 20, 30).initialize_copy}

    # initialize_copy behaves like set.
    t1 = Table.new(10, 20)
    t2 = Table.new(10)
    t2[5] = -20
    t1.send(:initialize_copy, t2)
    assert_equal(t1[5], -20)
    t1[3] = -2
    assert_equal(t2[3], 0)
  end

  def test_load
    # _load
    t = Table._load(genraw(1, 2, 1, 1, 2, [-1, 3]))
    assert_equal(t[0], -1)
    assert_equal(t[1], 3)
    assert_raise(ArgumentError) {t[0, 0, 0]}
    assert_raise(ArgumentError) {t[0, 0]}

    t = Table._load(genraw(2, 2, 2, 1, 4, [-1, 3, 2, 2]))
    assert_equal(t[0,0], -1)
    assert_equal(t[1,0], 3)
    assert_equal(t[0,1], 2)
    assert_equal(t[1,1], 2)
    assert_raise(ArgumentError) {t[0, 0, 0]}
    assert_raise(ArgumentError) {t[0]}

    t = Table._load(genraw(3, 2, 2, 2, 8, [-1, 3, 2, 2, 5, 4, -123, 2]))
    assert_equal(t[0,0,0], -1)
    assert_equal(t[1,0,0], 3)
    assert_equal(t[0,1,0], 2)
    assert_equal(t[1,1,0], 2)
    assert_equal(t[0,0,1], 5)
    assert_equal(t[1,0,1], 4)
    assert_equal(t[0,1,1], -123)
    assert_equal(t[1,1,1], 2)
    assert_raise(ArgumentError) {t[0, 0]}
    assert_raise(ArgumentError) {t[0]}
  end

  def test_dump
    # _dump
    t = Table.new(2)
    t[0] = -1
    t[1] = 3
    assert_equal(t._dump(1), genraw(1, 2, 1, 1, 2, [-1, 3]))

    t = Table.new(2, 2)
    t[0,0] = -1
    t[1,0] = 3
    t[0,1] = 2
    t[1,1] = 2
    assert_equal(t._dump(1), genraw(2, 2, 2, 1, 4, [-1, 3, 2, 2]))

    t = Table.new(2, 2, 2)
    t[0,0,0] = -1
    t[1,0,0] = 3
    t[0,1,0] = 2
    t[1,1,0] = 2
    t[0,0,1] = 5
    t[1,0,1] = 4
    t[0,1,1] = -123
    t[1,1,1] = 2
    assert_equal(t._dump(1), genraw(3, 2, 2, 2, 8, [-1, 3, 2, 2, 5, 4, -123, 2]))
  end

  def test_resize
    do_test = lambda {|sz1, sz2|
      t = Table.new(*sz1)
      (sz1[2] || 1).times do|z|
        (sz1[1] || 1).times do|y|
          (sz1[0] || 1).times do|x|
            t[*[x, y, z][0...sz1.size]] = (z * 10 + y) * 10 + x
          end
        end
      end
      t.resize(*sz2)
      assert_equal(t.xsize, sz2[0] || 1)
      assert_equal(t.ysize, sz2[1] || 1)
      assert_equal(t.zsize, sz2[2] || 1)
      (sz2[2] || 1).times do|z|
        (sz2[1] || 1).times do|y|
          (sz2[0] || 1).times do|x|
            val = t[*[x, y, z][0...sz2.size]]
            if z < (sz1[2] || 1) && y < (sz1[1] || 1) && x < (sz1[0] || 1) then
              assert_equal(val, (z * 10 + y) * 10 + x)
            else
              assert_equal(val, 0)
            end
          end
        end
      end
    }
    do_test.call([8, 8, 8], [7, 7, 7])
    do_test.call([8, 8, 8], [9, 7, 7])
    do_test.call([8, 8, 8], [7, 9, 7])
    do_test.call([8, 8, 8], [9, 9, 7])
    do_test.call([8, 8, 8], [7, 7, 9])
    do_test.call([8, 8, 8], [9, 7, 9])
    do_test.call([8, 8, 8], [7, 9, 9])
    do_test.call([8, 8, 8], [9, 9, 9])
    do_test.call([8, 8, 8], [7, 7])
    do_test.call([8, 8, 8], [9, 7])
    do_test.call([8, 8, 8], [7, 9])
    do_test.call([8, 8, 8], [9, 9])
    do_test.call([8, 8, 8], [7])
    do_test.call([8, 8, 8], [9])
    do_test.call([8, 8], [7, 7, 7])
    do_test.call([8, 8], [9, 7, 7])
    do_test.call([8, 8], [7, 9, 7])
    do_test.call([8, 8], [9, 9, 7])
    do_test.call([8, 8], [7, 7, 9])
    do_test.call([8, 8], [9, 7, 9])
    do_test.call([8, 8], [7, 9, 9])
    do_test.call([8, 8], [9, 9, 9])
    do_test.call([8, 8], [7, 7])
    do_test.call([8, 8], [9, 7])
    do_test.call([8, 8], [7, 9])
    do_test.call([8, 8], [9, 9])
    do_test.call([8, 8], [7])
    do_test.call([8, 8], [9])
    do_test.call([8], [7, 7, 7])
    do_test.call([8], [9, 7, 7])
    do_test.call([8], [7, 9, 7])
    do_test.call([8], [9, 9, 7])
    do_test.call([8], [7, 7, 9])
    do_test.call([8], [9, 7, 9])
    do_test.call([8], [7, 9, 9])
    do_test.call([8], [9, 9, 9])
    do_test.call([8], [7, 7])
    do_test.call([8], [9, 7])
    do_test.call([8], [7, 9])
    do_test.call([8], [9, 9])
    do_test.call([8], [7])
    do_test.call([8], [9])
    t = Table.new(10)
    assert_same(t.resize(10), t)
    assert_same(t.resize(10, 20), t)
    assert_same(t.resize(10, 20, 30), t)
    assert_equal(sizes(t.resize(10)), [10, 1, 1])
    assert_equal(sizes(t.resize(10, 20)), [10, 20, 1])
    assert_equal(sizes(t.resize(10, 20, 30)), [10, 20, 30])
    assert_equal(sizes(t.resize(0)), [0, 1, 1])
    assert_equal(sizes(t.resize(-10)), [0, 1, 1])
    assert_equal(sizes(t.resize(0, 20)), [0, 20, 1])
    assert_equal(sizes(t.resize(-10, 20)), [0, 20, 1])
    assert_equal(sizes(t.resize(10, 0)), [10, 0, 1])
    assert_equal(sizes(t.resize(10, -20)), [10, 0, 1])
    assert_equal(sizes(t.resize(0, 20, 30)), [0, 20, 30])
    assert_equal(sizes(t.resize(-10, 20, 30)), [0, 20, 30])
    assert_equal(sizes(t.resize(10, 0, 30)), [10, 0, 30])
    assert_equal(sizes(t.resize(10, -20, 30)), [10, 0, 30])
    assert_equal(sizes(t.resize(10, 20, 0)), [10, 20, 0])
    assert_equal(sizes(t.resize(10, 20, -30)), [10, 20, 0])
    assert_equal(sizes(t.resize(10.5)), [10, 1, 1])
    assert_equal(sizes(t.resize(10.5, 20.5)), [10, 20, 1])
    assert_equal(sizes(t.resize(10.5, 20.5, 30.5)), [10, 20, 30])
    assert_equal(rawheader(t.resize(10)), [1, 10, 1, 1, 10])
    assert_equal(rawheader(t.resize(10, 20)), [2, 10, 20, 1, 200])
    assert_equal(rawheader(t.resize(10, 20, 30)), [3, 10, 20, 30, 6000])
    assert_equal(rawheader(t.resize(-10)), [1, 0, 1, 1, 0])
    assert_equal(rawheader(t.resize(-10, 20)), [2, 0, 20, 1, 0])
    assert_equal(rawheader(t.resize(10, -20)), [2, 10, 0, 1, 0])
    assert_equal(rawheader(t.resize(-10, 20, 30)), [3, 0, 20, 30, 0])
    assert_equal(rawheader(t.resize(10, -20, 30)), [3, 10, 0, 30, 0])
    assert_equal(rawheader(t.resize(10, 20, -30)), [3, 10, 20, 0, 0])
    assert_raise(ArgumentError) { t.resize }
    assert_raise(ArgumentError) { t.resize(10, 20, 30, 40) }
    assert_raise(TypeError) { t.resize("10") }
    assert_raise(TypeError) { t.resize("10", 20) }
    assert_raise(TypeError) { t.resize(10, "20") }
    assert_raise(TypeError) { t.resize("10", 20, 30) }
    assert_raise(TypeError) { t.resize(10, "20", 30) }
    assert_raise(TypeError) { t.resize(10, 20, "30") }
    assert(Integer === t.resize(10.5).xsize)
    assert(Integer === t.resize(10.5, 20.5).xsize)
    assert(Integer === t.resize(10.5, 20.5).ysize)
    assert(Integer === t.resize(10.5, 20.5, 30.5).xsize)
    assert(Integer === t.resize(10.5, 20.5, 30.5).ysize)
    assert(Integer === t.resize(10.5, 20.5, 30.5).zsize)
  end

  def test_wrapping
    t = Table.new(10)
    t[0] = -200000
    t[1] = -160000
    t[2] = -120000
    t[3] = -80000
    t[4] = -40000
    t[5] = 0
    t[6] = 40000
    t[7] = 80000
    t[8] = 120000
    t[9] = 160000
    assert_equal(t[0], -3392)
    assert_equal(t[1], -28928)
    assert_equal(t[2], 11072)
    assert_equal(t[3], -14464)
    assert_equal(t[4], 25536)
    assert_equal(t[5], 0)
    assert_equal(t[6], -25536)
    assert_equal(t[7], 14464)
    assert_equal(t[8], -11072)
    assert_equal(t[9], 28928)
    t[0] = 32767
    t[1] = 32768
    t[2] = -32768
    t[3] = -32769
    assert_equal(t[0], 32767)
    assert_equal(t[1], -32768)
    assert_equal(t[2], -32768)
    assert_equal(t[3], 32767)
    t[0] = (1<<31)-1
    assert_raise(RangeError) { t[0] = (1<<31) }
    t[0] = -(1<<31)
    assert_raise(RangeError) { t[0] = -(1<<31)-1 }
  end

  def test_setters_argumenterror_buggy
    # BUGGY BEHAVIOR
    t = Table.new(10, 20, 30)
    t[4, 19] = 50
    assert_equal(t[4, 19, 0], 50)

    t = Table.new(10, 20)
    t[4] = 50
    assert_equal(t[4, 0], 50)

    t = Table.new(10)
    t[] = 50
    assert_equal(t[0], 50)
  end

  def test_wrongsize_buggy
    t = Table._load(genraw(1, 1, 1, 1, 10, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))
    assert_equal(t[0], 0)
    assert_equal(t[1], nil)
    assert_equal(rawdata(t), [1, 1, 1, 1, 10, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]])
    t = Table._load(genraw(1, 1, 1, 1, 5, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))
    assert_equal(rawdata(t), [1, 1, 1, 1, 5, [0, 1, 2, 3, 4]])
    t = Table._load(genraw(1, 1, 1, 1, 10, [0, 1, 2, 3, 4]))
    assert_equal(rawheader(t), [1, 1, 1, 1, 10])
    assert_equal(rawdata(t)[5].size, 10)

    t = Table._load(genraw(1, 1, 1, 1, 0, [0, 1]))
    assert_equal(t._dump(1).size, 20)
    t = Table._load(genraw(1, 1, 1, 1, -1, [0, 1]))
    assert_equal(t._dump(1).size, 18)
    t = Table._load(genraw(1, 1, 1, 1, -2, [0, 1]))
    assert_equal(t._dump(1).size, 16)
    t = Table._load(genraw(1, 1, 1, 1, -3, [0, 1]))
    assert_equal(t._dump(1).size, 14)
    t = Table._load(genraw(1, 1, 1, 1, -4, [0, 1]))
    assert_equal(t._dump(1).size, 12)
    t = Table._load(genraw(1, 1, 1, 1, -5, [0, 1]))
    assert_equal(t._dump(1).size, 10)
    t = Table._load(genraw(1, 1, 1, 1, -6, [0, 1]))
    assert_equal(t._dump(1).size, 8)
    t = Table._load(genraw(1, 1, 1, 1, -7, [0, 1]))
    assert_equal(t._dump(1).size, 6)
    t = Table._load(genraw(1, 1, 1, 1, -8, [0, 1]))
    assert_equal(t._dump(1).size, 4)
    t = Table._load(genraw(1, 1, 1, 1, -9, [0, 1]))
    assert_equal(t._dump(1).size, 2)
    # t = Table._load(genraw(1, 1, 1, 1, -10, [0, 1]))
    # assert_equal(t._dump(1).size, 0)
    # Segfault
    # t = Table._load(genraw(1, 1, 1, 1, -11, [0, 1]))
    # p t._dump(1)
  end

  def test_undefined_dim_buggy
    # t = Table._load(genraw(65537, 1, 1, 1, 1, [10]))
    # assert_raise(ArgumentError) { t[0] }
    t = Table._load(genraw(0, 1, 1, 1, 1, [10]))
    assert_equal(t[], 10)
    t = Table._load(genraw(4, 1, 1, 1, 1, [10]))
    assert_equal(t[0, 0, 0, 0], 10)
    assert_equal(t[0, 0, 0, -1], 10)
    # Segfault
    # assert_equal(t[0, 0, 0, 1], 10)
  end

  def test_negsize_buggy
    t = Table._load(genraw(1, -2, 1, 1, 0, []))
    assert_equal(sizes(t), [-2, 1, 1])
    assert_equal(rawheader(t), [1, -2, 1, 1, 0])
    assert_equal(t[0], nil)
  end
end

run_test(TestTable)
