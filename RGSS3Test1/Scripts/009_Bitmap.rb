class TestBitmap

  def test_class
    assert_equal(Bitmap.superclass, Object)
  end

  def test_constructor
    b = Bitmap.new(6, 4)
    4.times do|y|
      6.times do|x|
        assert_equal(b.get_pixel(x, y), Color.new(0.0, 0.0, 0.0, 0.0))
      end
    end

    b = Bitmap.new("Graphics/test1.png")
    assert_equal(b.height, 3)
    assert_equal(b.width, 5)
    expected_pixels = [
      [Color.new(212, 97, 255, 237),
       Color.new(0, 116, 255, 255),
       Color.new(26, 31, 255, 107),
       Color.new(251, 255, 177, 255),
       Color.new(41, 255, 255, 255)],
      [Color.new(255, 53, 133, 102),
       Color.new(57, 255, 255, 221),
       Color.new(255, 237, 4, 135),
       Color.new(104, 0, 0, 246),
       Color.new(0, 191, 0, 255)],
      [Color.new(255, 238, 125, 255),
       Color.new(223, 106, 85, 0),
       Color.new(198, 188, 27, 86),
       Color.new(148, 0, 0, 107),
       Color.new(105, 169, 175, 0)]
    ]
    3.times do|y|
      5.times do|x|
        assert_equal(b.get_pixel(x, y), expected_pixels[y][x])
      end
    end

    assert_raise(Errno::ENOENT) { Bitmap.new("Graphics/foo.png") }

    b = Bitmap.new("Graphics/test_png.jpg")
    assert_equal(b.get_pixel(0, 0), Color.new(255, 255, 255, 87))

    assert_raise(RGSSError) { Bitmap.new("Graphics/test_broken") }
  end

  def test_load_rtp
    b = Bitmap.new("Graphics/System/IconSet.png")
    assert_equal(b.get_pixel(0, 0), Color.new(120, 195, 128, 0))

    b = Bitmap.new("Graphics/System/Iconset.png")
    assert_equal(b.get_pixel(0, 0), Color.new(120, 195, 128, 0))
  end

  def test_load_order
    # "Graphics/test2" = Color.new(23, 185, 64, 193)
    # "Graphics/test2.png" = Color.new(210, 171, 0, 165)
    b = Bitmap.new("Graphics/test2")
    assert_equal(b.get_pixel(0, 0), Color.new(210, 171, 0, 165))

    # "Graphics/test3.png" = Color.new(0, 152, 255, 225)
    # "Graphics/test3.png.png" = Color.new(195, 189, 255, 255)
    b = Bitmap.new("Graphics/test3.png")
    assert_equal(b.get_pixel(0, 0), Color.new(195, 189, 255, 255))

    # "Graphics/test4" = Color.new(255, 129, 212, 255)
    b = Bitmap.new("Graphics/test4")
    assert_equal(b.get_pixel(0, 0), Color.new(255, 129, 212, 255))

    # "Graphics/test5" = Color.new(174, 96, 83, 212)
    # "Graphics/test5.png" = Color.new(126, 76, 255, 102)
    # "Graphics/test5.jpg" = Color.new(254,  1, 172, 255)
    # "Graphics/test5.jpeg" = Color.new(104, 10, 150, 255)
    # "Graphics/test5.bmp" = Color.new(255, 201, 14, 255)
    b = Bitmap.new("Graphics/test5")
    assert_equal(b.get_pixel(0, 0), Color.new(126, 76, 255, 102))

    # "Graphics/test6" = Color.new(255, 248, 255, 216)
    # "Graphics/test6.jpg" = Color.new(153, 144, 171, 255)
    # "Graphics/test6.jpeg" = Color.new(70, 71, 101, 255)
    # "Graphics/test6.bmp" = Color.new(185, 122, 87, 255)
    b = Bitmap.new("Graphics/test6")
    assert_equal(b.get_pixel(0, 0), Color.new(153, 144, 171, 255))

    # "Graphics/test7" = Color.new(82, 0, 0, 255)
    # "Graphics/test7.jpeg" = Color.new(185, 120, 0, 255)
    # "Graphics/test7.bmp" = Color.new(153, 217, 234, 255)
    b = Bitmap.new("Graphics/test7")
    assert_equal(b.get_pixel(0, 0), Color.new(82, 0, 0, 255))

    # "Graphics/test8.jpeg" = Color.new(217, 109, 109, 255)
    # "Graphics/test8.bmp" = Color.new(163, 73, 164, 255)
    b = Bitmap.new("Graphics/test8")
    assert_equal(b.get_pixel(0, 0), Color.new(163, 73, 164, 255))

    # "Graphics/test9.jpeg" = Color.new(255, 33, 56, 255)
    b = Bitmap.new("Graphics/test9")
    assert_equal(b.get_pixel(0, 0), Color.new(255, 33, 56, 255))

    # local = Color.new(255, 255, 255, 255)
    # RTP = Color.new(0, 0, 0, 255)
    b = Bitmap.new("Graphics/System/GameOver.png")
    assert_equal(b.get_pixel(0, 0), Color.new(255, 255, 255, 255))
  end

  def test_rect
    b = Bitmap.new(10, 20)
    assert_equal(b.rect, Rect.new(0, 0, 10, 20))
    assert_not_same(b.rect, b.rect)
  end

  def test_get_pixel
    b = Bitmap.new(10, 20)
    b.set_pixel(5, 6, Color.new(1, 2, 3, 4))
    assert_equal(b.get_pixel(5, 6), Color.new(1, 2, 3, 4))
    assert_equal(b.get_pixel(5.5, 6.5), Color.new(1, 2, 3, 4))
    assert_not_same(b.get_pixel(5, 6), b.get_pixel(5, 6))
    assert_equal(b.get_pixel(5, -5), Color.new)
    assert_not_same(b.get_pixel(5, -5), b.get_pixel(5, -5))
    assert_equal(b.get_pixel(-5, 5), Color.new)
    assert_raise(TypeError) { b.get_pixel("5", 3) }
    assert_raise(TypeError) { b.get_pixel(5, "3") }
  end

  def test_set_pixel
    b = Bitmap.new(10, 20)
    b.set_pixel(5, 6, Color.new(1.5, 2.5, 3.5, 4.5))
    assert_equal(b.get_pixel(5, 6), Color.new(1, 2, 3, 4))
    b.set_pixel(7.5, 3.6, Color.new(31.5, 32.5, 33.5, 34.5))
    assert_equal(b.get_pixel(7, 3), Color.new(31, 32, 33, 34))
    b = Bitmap.new(10, 20)
    b.set_pixel(5, -5, Color.new(41.5, 42.5, 43.5, 44.5))
    b.set_pixel(-5, 5, Color.new(41.5, 42.5, 43.5, 44.5))
    b.set_pixel(15, 5, Color.new(41.5, 42.5, 43.5, 44.5))
    b.set_pixel(5, 25, Color.new(41.5, 42.5, 43.5, 44.5))
    20.times do|y|
      10.times do|x|
        assert_equal(b.get_pixel(y, x), Color.new)
      end
    end
    assert_raise(TypeError) { b.set_pixel("5", 3, Color.new) }
    assert_raise(TypeError) { b.set_pixel(5, "3", Color.new) }
    assert_raise(TypeError) { b.set_pixel(5, 3, Object.new) }
  end

  def test_clear
    b = Bitmap.new(10, 20)
    20.times do|y|
      10.times do|x|
        b.set_pixel(x, y, Color.new(x, y, 3.5, 4.5))
      end
    end
    b.clear
    assert_equal(b.height, 20)
    assert_equal(b.width, 10)
    20.times do|y|
      10.times do|x|
        assert_equal(b.get_pixel(x, y), Color.new)
      end
    end
  end

  def test_clear_rect
    [false, true].product(
      [-3, 8],
      [2, 7],
      [6, 17, 23],
      [4, 7, 13]).each do|(call_with_rect, ry1, rx1, ry2, rx2)|
      b = Bitmap.new(10, 20)
      20.times do|y|
        10.times do|x|
          b.set_pixel(x, y, Color.new(x, y, 13.5, 14.5))
        end
      end
      if call_with_rect then
        b.clear_rect(Rect.new(rx1, ry1, rx2-rx1, ry2-ry1))
      else
        b.clear_rect(rx1, ry1, rx2-rx1, ry2-ry1)
      end
      assert_equal(b.height, 20)
      assert_equal(b.width, 10)
      20.times do|y|
        10.times do|x|
          if rx1 <= x && x < rx2 && ry1 <= y && y < ry2 then
            assert_equal(b.get_pixel(x, y), Color.new)
          else
            assert_equal(b.get_pixel(x, y), Color.new(x, y, 13, 14))
          end
        end
      end
    end
  end

  def test_fill_rect
    [false, true].product(
      [-3, 8],
      [-2, 7],
      [6, 17, 23],
      [4, 7, 13]).each do|(call_with_rect, ry1, rx1, ry2, rx2)|
      b = Bitmap.new(10, 20)
      20.times do|y|
        10.times do|x|
          b.set_pixel(x, y, Color.new(x, y, 13.5, 14.5))
        end
      end
      if call_with_rect then
        b.fill_rect(Rect.new(rx1, ry1, rx2-rx1, ry2-ry1), Color.new(101, 102, 103, 128))
      else
        b.fill_rect(rx1, ry1, rx2-rx1, ry2-ry1, Color.new(101, 102, 103, 128))
      end
      assert_equal(b.height, 20)
      assert_equal(b.width, 10)
      20.times do|y|
        10.times do|x|
          if rx1 <= x && x < rx2 && ry1 <= y && y < ry2 then
            assert_equal(b.get_pixel(x, y), Color.new(101, 102, 103, 128))
          else
            assert_equal(b.get_pixel(x, y), Color.new(x, y, 13, 14))
          end
        end
      end
    end
  end

  def test_gradient_fill_rect
    c1 = Color.new(0.2, 200.9, 254.7, 200.1)
    c2 = Color.new(254.5, 100.7, 100.1, 0.1)
    c1i = Color.new(c1.red.to_i, c1.green.to_i, c1.blue.to_i, c1.alpha.to_i)
    c2i = Color.new(c2.red.to_i, c2.green.to_i, c2.blue.to_i, c2.alpha.to_i)
    [false, true].product(
      [nil, false, true],
      [-3, 8],
      [-2, 7],
      [6, 17, 23],
      [4, 7, 13]).each do|(call_with_rect, vertical, ry1, rx1, ry2, rx2)|
      sy1 = ry1
      sx1 = rx1
      sy2 = ry2-1
      sx2 = rx2-1
      b = Bitmap.new(10, 20)
      20.times do|y|
        10.times do|x|
          b.set_pixel(x, y, Color.new(x, y, 13.5, 14.5))
        end
      end
      if call_with_rect then
        if vertical.nil? then
          b.gradient_fill_rect(Rect.new(rx1, ry1, rx2-rx1, ry2-ry1), c1, c2)
        else
          b.gradient_fill_rect(Rect.new(rx1, ry1, rx2-rx1, ry2-ry1), c1, c2, vertical)
        end
      else
        if vertical.nil? then
          b.gradient_fill_rect(rx1, ry1, rx2-rx1, ry2-ry1, c1, c2)
        else
          b.gradient_fill_rect(rx1, ry1, rx2-rx1, ry2-ry1, c1, c2, vertical)
        end
      end
      assert_equal(b.height, 20)
      assert_equal(b.width, 10)
      20.times do|y|
        10.times do|x|
          if vertical || (!call_with_rect && vertical == false) then
            factor_a = y-sy1
            factor_b = sy2-sy1
          else
            factor_a = x-sx1
            factor_b = sx2-sx1
          end
          expected = Color.new(
            c1i.red + ((c2i.red - c1i.red) * factor_a / factor_b).to_i,
            c1i.green + ((c2i.green - c1i.green) * factor_a / factor_b).to_i,
            c1i.blue + ((c2i.blue - c1i.blue) * factor_a / factor_b).to_i,
            c1i.alpha + ((c2i.alpha - c1i.alpha) * factor_a / factor_b).to_i)
          if rx1 <= x && x < rx2 && ry1 <= y && y < ry2 then
            assert_equal(b.get_pixel(x, y), expected)
          else
            assert_equal(b.get_pixel(x, y), Color.new(x, y, 13, 14))
          end
        end
      end
    end
  end

  def blend(destc, srcc, opacity)
    if opacity == 0 then
      return destc
    end
    destcr = destc.red.to_i
    destcg = destc.green.to_i
    destcb = destc.blue.to_i
    destca = destc.alpha.to_i
    srccr = srcc.red.to_i
    srccg = srcc.green.to_i
    srccb = srcc.blue.to_i
    srcca = (srcc.alpha.to_i * opacity + 127) / 255
    newa = (255-srcca)*destca+srcca*255
    if newa == 0 then
      return srcc
    end
    coef = 255 - 255*255*srcca/newa
    # coef = (256*(255-y)*x+255*y)/((255-srcca)*destca+srcca*255)
    if srcca == 30 && (destca == 51 || destca == 136) ||
       srcca == 105 && destca == 204 ||
       srcca == 180 && destca == 153 ||
       srcca == 210 && destca == 85 ||
       srcca == 0 then
      coef += 1
    end
    Color.new(
      srccr + (destcr - srccr) * coef / 256,
      srccg + (destcg - srccg) * coef / 256,
      srccb + (destcb - srccb) * coef / 256,
      newa / 255)
  end

  def test_blt
    [nil, 0, 100, 255].product(
      [12, -13],
      [14, -15],
      [1, -2],
      [2, -3],
      [3, -4],
      [4, -5],
      [2, -3],
      [3, -4],
      [4, -5],
      [5, -6]
    ).each do|
        (opacity, regionh, regionw,
         ymargin1, xmargin1, ymargin2, xmargin2,
         ymargin3, xmargin3, ymargin4, xmargin4)|
      srch = regionh.abs + ymargin1 + ymargin2
      srcw = regionw.abs + xmargin1 + xmargin2
      desth = regionh.abs + ymargin3 + ymargin4
      destw = regionw.abs + xmargin3 + xmargin4
      srcb = Bitmap.new(srcw, srch)
      srch.times do|y|
        srcw.times do|x|
          srcb.set_pixel(
            x, y,
            Color.new(
              x * 255 / (srcw-1),
              y * 255 / (srch-1),
              x * 255 / (srcw-1),
              y * 255 / (srch-1)))
          # srcb.set_pixel(
          #   x, y,
          #   Color.new(y, x, 0, 255))
        end
      end
      destb = Bitmap.new(destw, desth)
      simdestb = Bitmap.new(destw, desth)
      # origb = Bitmap.new(destw, desth)
      desth.times do|y|
        destw.times do|x|
          destb.set_pixel(
            x, y,
            Color.new(
              255 - x * 255 / (destw-1),
              x * 255 / (destw-1),
              y * 255 / (desth-1),
              x * 255 / (destw-1)))
          # destb.set_pixel(
          #   x, y,
          #   Color.new(0, y, x, 0))
          simdestb.set_pixel(x, y, destb.get_pixel(x, y))
          # origb.set_pixel(x, y, destb.get_pixel(x, y))
        end
      end
      blt_srcy = ymargin1
      blt_desty = ymargin3
      blt_srcx = xmargin1
      blt_destx = xmargin3
      if regionh < 0 then
        blt_srcy -= regionh
      end
      if regionw < 0 then
        blt_srcx -= regionw
      end
      blt_srcrect = Rect.new(blt_srcx, blt_srcy, regionw, regionh)
      if opacity.nil? then
        destb.blt(blt_destx, blt_desty, srcb, blt_srcrect)
      else
        destb.blt(blt_destx, blt_desty, srcb, blt_srcrect, opacity)
      end
      dest_starty = blt_desty
      dest_startx = blt_destx
      src_starty = blt_srcy
      src_startx = blt_srcx
      county = regionh.abs
      countx = regionw.abs
      src_stepy = 1
      src_stepx = 1
      if regionh >= 0 then
      else
        src_stepy = -1
        src_starty -= 1
      end
      if regionw >= 0 then
      else
        src_stepx = -1
        src_startx -= 1
      end

      if src_stepy < 0 && src_starty+1 - county < 0 then
        dest_starty -= src_starty+1 - county
        county += src_starty+1 - county
      elsif src_stepy > 0 && src_starty < 0 then
        county += src_starty
        dest_starty -= src_starty
        src_starty -= src_starty
      end
      if src_stepx < 0 && src_startx+1 - countx < 0 then
        dest_startx -= src_startx+1 - countx
        countx += src_startx+1 - countx
      elsif src_stepx > 0 && src_startx < 0 then
        countx += src_startx
        dest_startx -= src_startx
        src_startx -= src_startx
      end
      if dest_starty < 0 then
        county += dest_starty
        src_starty -= dest_starty * src_stepy
        dest_starty -= dest_starty
      end
      if dest_startx < 0 then
        countx += dest_startx
        src_startx -= dest_startx * src_stepx
        dest_startx -= dest_startx
      end
      if src_stepy < 0 && src_starty > srch-1 then
        county -= src_starty-(srch-1)
        src_starty = srch-1
      elsif src_stepy > 0 && src_starty + county > srch then
        county = srch - src_starty
      end
      if src_stepx < 0 && src_startx > srcw-1 then
        countx -= src_startx-(srcw-1)
        src_startx = srcw-1
      elsif src_stepx > 0 && src_startx + countx > srcw then
        countx = srcw - src_startx
      end
      if dest_starty + county > desth then
        county = desth - dest_starty
      end
      if dest_startx + countx > destw then
        countx = destw - dest_startx
      end

      desty = dest_starty
      srcy = src_starty
      county.times do
        destx = dest_startx
        srcx = src_startx
        countx.times do
          # begin
            assert(0 <= srcy && srcy < srch)
            assert(0 <= srcx && srcx < srcw)
          # rescue
          #   puts "opacity=#{opacity}, region=(#{regionh},#{regionw}), src_margin=(#{ymargin1},#{xmargin1},#{ymargin2},#{xmargin2}), dest_margin=(#{ymargin3},#{xmargin3},#{ymargin4},#{xmargin4})"
          #   puts "dest_pos=(#{desty},#{destx})"
          #   puts "src_pos=(#{srcy},#{srcx})"
          #   puts "dest size=(#{desth},#{destw})"
          #   puts "src size=(#{srch},#{srcw})"
          #   puts "dest_start=(#{dest_starty},#{dest_startx})"
          #   puts "src_start=(#{src_starty},#{src_startx})"
          #   puts "src_step=(#{src_stepy},#{src_stepx})"
          #   puts "count=(#{county},#{countx})"
          #   raise
          # end
          simdestb.set_pixel(
            destx, desty,
            blend(
              simdestb.get_pixel(destx, desty),
              srcb.get_pixel(srcx, srcy),
              opacity || 255))
          destx += 1
          srcx += src_stepx
        end
        desty += 1
        srcy += src_stepy
      end

      desth.times do|y|
        destw.times do|x|
          c_expected = simdestb.get_pixel(x, y)
          c_result = destb.get_pixel(x, y)
          # begin
            if c_expected then
              assert_equal(c_result, c_expected)
            end
          # rescue
          #   puts "opacity=#{opacity}, region=(#{regionh},#{regionw}), src_margin=(#{ymargin1},#{xmargin1},#{ymargin2},#{xmargin2}), dest_margin=(#{ymargin3},#{xmargin3},#{ymargin4},#{xmargin4})"
          #   puts "dest_pos=(#{y},#{x})"
          #   puts "result(blt)=#{c_result}"
          #   puts "expected   =#{c_expected}"
          #   puts "original   =#{origb.get_pixel(x, y)}"
          #   puts "dest size=(#{desth},#{destw})"
          #   puts "src size=(#{srch},#{srcw})"
          #   puts "dest_start=(#{dest_starty},#{dest_startx})"
          #   puts "src_start=(#{src_starty},#{src_startx})"
          #   puts "src_step=(#{src_stepy},#{src_stepx})"
          #   puts "count=(#{county},#{countx})"
          #   raise
          # end
        end
      end
    end
  # rescue
  #   p $!
  #   p $!.backtrace
  #   raise
  end
end

run_test(TestBitmap)

