-- initialize rgb
gpio.mode(6, gpio.OUTPUT) --gnd
gpio.write(6, gpio.HIGH)

pwm.setup(5, 1000, 1023) --r
pwm.setup(7, 1000, 1023) --g
pwm.setup(8, 1000, 1023) --b

function fade()
  cr = pwm.getduty(5)
  cg = pwm.getduty(7)
  cb = pwm.getduty(8)
  
  nr = 1023 - r*1023/255
  ng = 1023 - g*1023/255
  nb = 1023 - b*1023/255
    
  if(cr-nr > v) then pwm.setduty(5, cr-v)
  elseif(nr-cr > v) then pwm.setduty(5, cr+v)
  else pwm.setduty(5, nr) end
  
  if(cg-ng > v) then pwm.setduty(7, cg-v)
  elseif(ng-cg > v) then pwm.setduty(7, cg+v)
  else pwm.setduty(7, ng) end
    
  if(cb-nb > v) then pwm.setduty(8, cb-v)
  elseif(nb-cb > v) then pwm.setduty(8, cb+v)
  else pwm.setduty(8, nb) end
              
  if(cr~=nr or cg~=ng or cb~=nb ) then node.task.post(fade) end
end

--test fade
r = node.random(255)
g = node.random(255)
b = node.random(255)
v = 1 -- fade speed
fade()
