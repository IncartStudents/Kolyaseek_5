using Test
using FileUtils

srcpath = joinpath(@__DIR__, "files/box51/00016189_4.json")
dstpath = joinpath(@__DIR__, "files/box51/00016189_4_copy.json")

mkp1 = try FileUtils.Box51API.read_box51_json(srcpath) catch _ missing end
@test !ismissing(mkp1)

FileUtils.Box51API.write_box51_json(dstpath, mkp1)
@test try FileUtils.Box51API.read_box51_json(dstpath); true catch _ false end

# глупо сравнивать просто по тексту, потому что ошибки могут возникнуть просто из-за формати-
# рования, но переопределять логическое равно для каждой кастомной структуры не хочу. пока
# что пишем всё через json3.pretty, так что форматирование должно совпадать.
@test all(readlines(srcpath) .== readlines(dstpath))
