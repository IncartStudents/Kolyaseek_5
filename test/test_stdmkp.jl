using Test
using FileUtils

srcpath = joinpath(@__DIR__, "files/stdecgdb/8s001474_1.json")
dstpath = joinpath(@__DIR__, "files/stdecgdb/8s001474_1_copy.json")

mkp1 = try FileUtils.StdEcgDbAPI.read_stdmkp_json(srcpath) catch _ missing end
@test !ismissing(mkp1)

FileUtils.StdEcgDbAPI.write_stdmkp_json(dstpath, mkp1)
mkp2 = try FileUtils.StdEcgDbAPI.read_stdmkp_json(dstpath) catch _ missing end
@test !ismissing(mkp2)

# глупо сравнивать просто по тексту, потому что ошибки могут возникнуть из-за рандомных причин, 
# но переопределять логическое равно для каждой кастомной структуры не хочу, так что пока так
string(mkp1) == string(mkp2)