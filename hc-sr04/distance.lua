--ULTRA SONIC DISTANCE MEASURE

--vcc needs to be at 5v
echo = 1 --gpio
trig = 2 --gpio
start = 0
dist = 0

gpio.mode(trig, gpio.OUTPUT, gpio.PULLUP)
gpio.mode(echo, gpio.INT)

--The distance is returned by the length of a high pulse
gpio.trig(echo, 'both', function(level, time)
 if level==1 then start = time
 else dist = (time-start)* 10 / 292/ 2 print(dist..'cm') end
end)

--Start new measurement requires a high pulse (10us)
--gpio.serout cause strange error but this works
tmr.create():alarm(100, tmr.ALARM_AUTO, function()
  gpio.write(trig, 0)
  gpio.write(trig, 1)
  gpio.write(trig, 0)
end)
