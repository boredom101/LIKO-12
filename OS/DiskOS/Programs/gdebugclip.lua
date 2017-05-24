print("")
local data = clipboard()
data = math.b64dec(data)
data = math.decompress(data,"lz4")
fs.write("C://gdebugclip.lk12",data)
--color(12) print("Saved debug image successfully")
clear(1)
local img = image(data)
img:draw(1,1)

local sw,sh = screenSize()

for event in pullEvent do
 if event == "update" then
  clear(1)
  img:draw(1,1)
  local mx,my = getMPos()
  point(mx,my,11)
  color(8) print(mx..","..my,5,sh-8)
 end
 if event == "keypressed" then return end
end