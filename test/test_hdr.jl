using Test
using FileUtils
using StructArrays
using Tables

# =========================================================
# @testset "read hdr+rawdata from file" begin

path = joinpath(@__DIR__, "files/bintable/016997_highHR.hdr")

h = readheader(path)
rawdata = FileUtils.readbin(path, h, 1:10)
rawcols = Tables.columns(StructVector(rawdata))
@test length(rawcols[1]) == 10
@test rawcols[1][1:6] == [387, 353, 372, 369, 374, 344]
# using Plots
# plot(data[1][1:1000])

# end # testset

# =========================================================
# @testset "hdr codes utf8/utf8 bom/ascii" begin

# проверка hdr в трех кодировках
f1 = joinpath(@__DIR__,raw"files/headers/utf-8-bom.hdr")
f2 = joinpath(@__DIR__,raw"files/headers/utf-8.hdr")
f3 = joinpath(@__DIR__,raw"files/headers/ansi-win-1251.hdr")

h1 = readhdr(f1)
@test h1.colunits[1]=="µV" # исправило

h2 = readhdr(f2)
@test h2.colunits[1]=="mkV" # прочитало и не исказило

h3 = readhdr(f3)
@test h3.colunits[1]=="µV" # исправило
@test h3.colunits[15]=="µmHg" # исправило

# end # testset
