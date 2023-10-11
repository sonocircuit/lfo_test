-- lfo lib test
--
-- k2: lfo on/off
-- enc2: lfo depth
-- enc3: test param
-- k3 + enc2: lfo offset
--
--

--_lfos = include "lib/lfo" -- comment out accordingly to test diff behaviour
_lfos = require 'lfo'

shift = false

function init()

  params:add_control("level", "level", controlspec.new(0, 100, 'lin', 0, 0, ""))
  params:set_action("level", function(val) test_lfo.prev_value = val redraw() end)

  test_lfo = _lfos:add{
    shape = 'sine',
    min = 0,
    max = 100,
    mode = 'free',
    period = 6,
    baseline = 'min',
    action = function(scaled, raw) params:set("level", scaled) end
  }
  
  test_lfo:add_params("test_lfo", "level")

  params:bang()
end

function key(n, z)
  if n == 2 and z == 1 then
    params:set("lfo_test_lfo", params:get("lfo_test_lfo") == 1 and 2 or 1)
  elseif n == 3 then
    shift = z == 1 and true or false
  end
  redraw()
end

function enc(n, d)
  if n == 2 then
    if shift then
      params:delta("lfo_offset_test_lfo", d)
    else
      params:delta("lfo_depth_test_lfo", d)
    end
  elseif n == 3 then
    params:delta("level", d)
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.font_size(16)
  screen.level(4)
  screen.move(36, 26)
  if shift then
    screen.text_center(params:string("lfo_offset_test_lfo"))
  else
    screen.text_center(params:string("lfo_depth_test_lfo"))
  end
  screen.level(15)
  screen.move(84, 26)
  screen.text_center(params:string("level"))
  screen.move(28, 40)
  screen.line_width(2)
  screen.line_rel(71, 0)
  screen.move(util.linlin(0, 100, 28, 98, params:get("level")), 35)
  screen.line_rel(0, 10)
  screen.stroke()
  screen.update()
end
