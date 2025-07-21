using Test
using FileUtils
using Dates
using Tables, StructArrays

# тест конвертации в ГОСТ-47 из разных форматов файлов

annfile = joinpath(Base.@__DIR__, "files/physionet/1201.atr")
xmlfile = joinpath(Base.@__DIR__, "files/ox112785.000/AlgResult.xml")
csvfile = joinpath(Base.@__DIR__, "files/physionet/1201/qrs_forms.csv")
binfile = joinpath(Base.@__DIR__, "files/physionet/1201/NameQRS.toml")

beats1, seg_AF1, seg_VF1, meta1 = read_gost47(annfile)
beats2, seg_AF2, seg_VF2, meta2 = read_gost47(xmlfile)
beats3, seg_AF3, seg_VF3, meta3 = read_gost47(csvfile)
beats4, seg_AF4, seg_VF4, meta4 = read_gost47(binfile)

@test Tables.schema(beats1) === Tables.schema(beats2) === Tables.schema(beats3) === Tables.schema(beats4)
