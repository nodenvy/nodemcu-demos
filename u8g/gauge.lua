node.setcpufreq(node.CPU160MHZ)

function init_i2c_display()
  gpio.mode(1, gpio.OUTPUT) --gnd
  gpio.write(1, 0)
  gpio.mode(2, gpio.OUTPUT) --vcc
  gpio.write(2, 1)
  local sda = 4
  local scl = 3
  local sla = 0x3c
  i2c.setup(0, sda, scl, i2c.SLOW)
  disp = u8g.ssd1306_128x64_i2c(sla)
  disp:setFont(u8g.font_6x10)
  disp:setFontRefHeightExtendedText()
  disp:setDefaultForegroundColor()
  disp:setFontPosTop()
end

function print_OLED(label, val, min, max)
 local calc = (val-min)*100/(max-min)
 disp:firstPage()
 repeat
   disp:setColorIndex(1)
   disp:drawDisc(64, 64, 42)
   disp:setColorIndex(0)
   disp:drawDisc(64, 64, 30)
   if calc < 0 then
     disp:drawTriangle(63,63, 63,0, 0,63)
     disp:drawTriangle(63,63, 63,0, 127,63)
   elseif calc < 50 then
     disp:drawTriangle(63,63, 63,0, calc*63/50,63-calc*63/50)
     disp:drawTriangle(63,63, 63,0, 127,63)
   elseif calc < 100 then
     disp:drawTriangle(63,63, 63,0, 63,0)
     disp:drawTriangle(63,63, 63+(calc-50)*63/50,(calc-50)*63/50, 127,63)
   else
     disp:drawTriangle(63,63, 63,0, 63,0)
     disp:drawTriangle(63,63, 127,63, 127,63)
   end
   disp:setColorIndex(1)
   disp:drawCircle(64, 64, 42)
   disp:drawCircle(64, 64, 30)
   disp:drawStr(110, 56, max)
   disp:drawStr(20-disp:getStrWidth(min), 56, min)
   disp:setScale2x2()
   disp:drawStr(33-disp:getStrWidth(label)/2, 0, label)
   disp:drawStr(33-disp:getStrWidth(val)/2, 22, val)
   disp:undoScale()
  until disp:nextPage() == false
end

init_i2c_display()

print_OLED('Temp', -20, -10, 40)
print_OLED('Temp', -10, -10, 40)
print_OLED('Temp', 24, -10, 40)
print_OLED('Temp', 60, -10, 40)
