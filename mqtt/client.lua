-- Auto-reconects every time the connection is lost

endp = 'mqttbroker.example'
port = 1883
user = 'user'
pass = 'pass'

mq = mqtt.Client("client-id-"..node.chipid(), 120, user, pass)

mq:on("message", function(client, topic, data)
  print(topic, data)
end)

function mq_ok(client)
  print("connected")
  mq:subscribe({ ["deviceid/evt/evt1"]=0, ["deviceid/evt/evt2"]=0 }) --qos=0
  mq:publish(node.chipid().."/cmd/data", 'test', 0, 0 }) --qos=0 and retain=0
end

function mq_ko(client, reason)
  print("failed reason: " .. reason)
  tmr.create():alarm(1000, tmr.ALARM_SINGLE, mq_connect)
end

function mq_connect()
  print('connecting...')
  mq:connect(endp, port, 0, mq_ok, mq_ko)
end

mq_connect()
