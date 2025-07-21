using Test
using FileUtils
using StructArrays
using Tables
# using Plots

# эти тесты отключены, т.к. dat-файлы слишком большие для репозитория

#=
datpath = joinpath(@__DIR__, "files/datfiles/MX22130213131241.dat")
# datpath = raw"Y:\yura\Data\MX22130213131241.dat"
datpath = raw"C:\Users\gvg\binECG\temp\MX22130213131241.dat"
=#
datpath = joinpath(@__DIR__,"/home/kolyaseek/ChildArithm.dat")

datpath = raw"/home/kolyaseek/TEST/ChildArithm.dat"

h = FileUtils.readdatheader(datpath);

XMapToDict = FileUtils.readdatimap(datpath);

data = FileUtils.readdatcols(datpath, 1:1000);
#=
plts = Array{Plots.Plot{Plots.GRBackend},1}()
for i = 1:8
    push!(plts, plot(data[i]))
end
plot(
    plts[1], plts[2], plts[3], plts[4],
    plts[5], plts[6], plts[7], plts[8],
    layout = (4,2), legend = false
)
=#

@test XMapToDict["Ch0.Des"] === "L"
@test XMapToDict["Ch21.Des"] === "Tone"
@test data[1][1]    == 16741
@test data[1][1000] == 16415
@test data[8][1000] == -12465


# выведем список всех метаданных:
s = [string(k, " => ", v) for (k,v) in XMapToDict]
sort(s) .|> println;