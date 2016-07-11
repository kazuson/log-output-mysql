require 'date'
require 'mysql2'


def get_last_line file_path
  lastline = ""
  open(file_path) do |file|
    lines = file.read
    lines.each_line do |line|
    lastline = line
    end
  end
  return lastline
end

def convert_Array line
  arrayline=line.split(",")
  return arrayline
end

def readupdatetime
  updatetime = File::stat("D20160710.dat")
  updatetime2 = File::stat("D20160710.dat")
  while updatetime == updatetime2
    updatetime2 = File::stat("D20160710.dat")
  end
end

readupdatetime

day = Date::today
day = day.to_s

line = get_last_line("D20160710.dat")
p line
arrayline = convert_Array(line)
p arrayline

starttime = day + "\s" + arrayline[0]
finishtime = day + "\s" + arrayline[1]
estimatedstart = arrayline[2]
estimatedfinish = arrayline[3]
sex = arrayline[4]
gender = arrayline[5].to_i
sojourntime = arrayline[6].to_i
viewingtime = arrayline[7].to_i
facesize = arrayline[8].to_f
distancecategory = arrayline[9].chomp

#列挙型のための条件分岐、-1が帰ってきた時はプログラムを抜ける
case sex
when "1" then
  sex = "male"
when "0" then
  sex = "female"
when "-1" then
  #sex = "nodata"
  exit!
end


if estimatedstart == "-1"
  estimatedstart = day + "\s" + "00:00:00"
else
  estimatedstart = day + "\s" + estimatedstart
end

if estimatedfinish == "-1"
  estimatedfinish = day + "\s" + "00:00:00"
else
  estimatedfinish = day + "\s" + estimatedfinish
end


keyAry = ["starttime","finishtime","estimatedstart","estimatedfinish","sex","gender","sojourntime","viewingtime","facesize","distancecategory"]
keyValue =
[starttime,finishtime,estimatedstart,estimatedfinish,sex,gender,sojourntime,viewingtime,facesize,distancecategory]
ary = [keyAry,keyValue].transpose
h = Hash[*ary.flatten]
p h
p h["starttime"]

client = Mysql2::Client.new(:host => "localhost", :username => "dbuser", :password => "kazuma1212", :database => "blog_app")

#client.query("INSERT INTO analysis
#(starttime,finishtime,estimatedstart,estimatedfinish,sex,gender,sojourntime,viewingtime,facesize,distancecategory) VALUES  #(\`#{h["starttime"]}\`,\`#{h[finishtime]}\`,\`#{h[estimatedstart]}\`,\`#{h[estimatedfinish]}\`,\`#{h[sex]}\`,#{h[gender]},#{h[#sojourntime]},#{h[viewingtime]},#{h[facesize]},\`#{h[distancecategory]}\`)")
client.query("INSERT INTO analysis (starttime, finishtime, estimatedstart, estimatedfinish, sex, gender, sojourntime,  viewingtime, facesize, distancecategory) VALUES ('#{h["starttime"]}','#{h["finishtime"]}','#{h["estimatedstart"]}','#{h["estimatedfinish"]}','#{h["sex"]}','#{h["gender"]}','#{h["sojourntime"]}','#{h["viewingtime"]}','#{h["facesize"]}','#{h["distancecategory"]}')")




#
# p starttime
# p finishtime
# p estimatedstart
# p estimatedfinish
# p sex
# p gender
# p sojourntime
# p viewingtime
# p facesize
# p distancecategory
