local source = select(1,...)

local term = require("C://terminal")

if source then source = term.parsePath(source)..".lk12" end

print("") --NewLine

if not source then color(9) print("Must provide path to the file to load") return end
if not fs.exists(source) then color(9) print("File doesn't exists") return end
if fs.isDirectory(source) then color(9) print("Couldn't load a directory !") return end

local saveData = fs.read(source) .. ";"
if not saveData:sub(0,5) == "LK12;" then color(9) print("This is not a valid LK12 file !!") return end

--LK12;OSData;OSName;DataType;Version;Compression;CompressLevel; data"
--local header = "LK12;OSData;DiskOS;DiskGame;V"..saveVer..";"..sw.."x"..sh..";C:"

local nextarg = saveData:gmatch("(.-);")
nextarg() --Skip LK12;

local filetype = nextarg()
if not filetype then color(9) print("Invalid Data !") return end
if filetype ~= "OSData" then color(9) print("Can't load '"..filetype.."' files !") return end

local osname = nextarg()
if not osname then color(9) print("Invalid Data !") return end
if osname ~= "DiskOS" then color(9) print("Can't load files from '"..osname.."' OS !") return end

local datatype = nextarg()
if not datatype then color(9) print("Invalid Data !") return end
if datatype ~= "DiskGame" then color(9) print("Can't load '"..datatype.."' from '"..osname.."' OS !") return end

local dataver = nextarg()
if not dataver then color(9) print("Invalid Data !") return end
dataver = tonumber(string.match(dataver,"V(%d+)"))
if not dataver then color(9) print("Invalid Data !") return end
if dataver > _DiskVer then color(9) print("Can't load disks newer than V".._DiskVer..", provided: "..dataver) return end

local sw, sh = screenSize()

local datares = nextarg()
if not datares then color(9) print("Invalid Data !") return end
local dataw, datah = string.match(datares,"(%d+)x(%d+)")
if not (dataw and datah) then color(9) print("Invalid Data !") return end dataw, datah = tonumber(dataw), tonumber(datah)
if dataw ~= sw or datah ~= sh then color(9) print("This disk is made for GPUs with "..dataw.."x"..datah.."res, current GPU is "..sw.."x"..sh) return end

local compress = nextarg()
if not compress then color(9) print("Invalid Data !") return end
compress = string.match(compress,"C:(.+)")
if not compress then color(9) print("Invalid Data !") return end

local clevel = nextarg()
if not clevel then color(9) print("Invalid Data !") return end
clevel = string.match(clevel,"CLvl:(.+)")
if not clevel then color(9) print("Invalid Data !") return end clevel = tonumber(clevel)

local data = ""
for d in nextarg do data = data..d..";" end --Read the data itself
data = data:sub(0,-2) --Strip the last ;

if compress ~= "none" then --Decompress
  data = math.decompress(data,compress,clevel)
end

local eapi = require("C://Editors")
eapi:import(data)

color(12) print("Loaded successfully")
