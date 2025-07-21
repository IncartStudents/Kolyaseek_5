using Test
using FileUtils

# =========================================================
# @testset "read bin+toml-v1 from file" begin

# path = joinpath(@__DIR__, "files/bintable/QSBoundExact.toml")
path = joinpath(@__DIR__, "files/bintable/016997_highHR/QrsBndMerge.toml")
h = readheader(path)
tab, meta = readtable(BinToml, path)
@test all(tab.result[1:5] .== :good)

# end

# =========================================================
# @testset "read bin+toml-v1 convert to toml-v2 file" begin

path = joinpath(@__DIR__, "files/bintable/QSBoundExact.toml")
h = readheader(path)

path2 = joinpath(@__DIR__, "files/bintable/QSBoundExact_2.toml")
savetomlheader(path2, h)
h1 = readheader(path2)
rm(path2)

@test h.tabletype == h1.tabletype
@test h.fs == h1.fs
@test h.timestart == h1.timestart
@test h.offset == h1.offset
@test h.colnames == h1.colnames
@test h.colunits == h1.colunits
# h.encodings == h1.encodings не реализовано

# end
