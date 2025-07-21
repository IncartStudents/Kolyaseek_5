using IBoxAccess
using FileUtils
using Test
filepath = "test/files/dat/oxy115829.dat"

ip, port = IBoxAccess.runIBox(filepath)

datakey = "Mark/QRS"
QRS = readIBtable(ip, port, datakey)
@test isa(QRS, SegmentsTable)

datakey = "Mark/EcgChannals"
ecg = readIBtable(ip, port, datakey)
@test isa(ecg, SignalTable)

tree = IBoxAccess.gettree(ip, port)
subtree = gettree(ip, port,"Mark/EcgChannals")
childs = IBoxAccess.getchildnames(ip, port,"Mark/EcgChannals")

closeIBox(ip, port)

filepath = "C:/Temp/config.txt"
str = read(filepath, String)
using TOML
dict = TOML.parse(str)
