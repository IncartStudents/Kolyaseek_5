
using Test
using FileUtils
using StructArrays
using Tables
using Dates

# ============ сигналы ================
# @testset "sample signals write-read: hdr, toml, h5" begin

fs = 250
sig = StructVector(
    chan0 = collect(1:10), # int
    chan1 = fill(5, 10), # int
    chan2 = collect(1:10) * 5.0, # float
)

file_sig = "tab_sig"
savetable(BinHdr, "$file_sig.hdr", sig, fs, colunits = [:uV, :uV, :uV])
sig1, meta1 = readtable(BinHdr, "$file_sig.hdr") # all channels to float
rm("$file_sig.hdr")
rm("$file_sig.bin")

savetable(BinToml, "$file_sig.toml", sig, fs, colunits = [:uV, :uV, :uV])
sig2, meta2 = readtable(BinToml, "$file_sig.toml") # types preserved
rm("$file_sig.toml")
rm("$file_sig.bin")

savetable(H5Format, "$file_sig.h5", sig, fs, colunits = [:uV, :uV, :uV])
sig3, meta3 = readtable(H5Format, "$file_sig.h5") # types preserved
rm("$file_sig.h5")

@test sig == sig1 # вроде типы разные, но сравнивает по значениям
@test sig == sig2
@test sig == sig3

# end # testset

# =========== сегменты / события ================
# @testset "sample marks write-read: toml, h5" begin

fs = 250
qrs = StructVector((;
    timeQ = Int32[174, 280, 500, 649, 800],
    timeS = Int32[195, 309, 514, 664, 816],
    verified = Int32[0, 0, 0, 0, 0],
    form_id = [:X, :U, :U, :U, :V],
    subform_id = Int32[1, 1, 1, 1, 1],
    class_id = Int32[-1, 32823, 32823, 32823, 10],
    prem_id = [:undef, :undef, :_pN, :undef, :_pP],
    RR = [NaN, 1120.0, 880.0, 596.0, 604.0],
    timePstart = Int32[141, 226, 463, 616, 766],
    timeTendmax = Int32[265, 371, 589, 739, 885],
    angleP = Int32[81, 62, 68, 92, 73],
    angleQRS = Int32[95, 98, 97, 92, 94],
    transZone = Int32[3, 3, 3, 3, 3],
    diag = Int32[63, 72, 102, 91, 77],
    st1 = StructVector((
        Int32[0, 43, 7, 45, 3],
        Int32[0, -149, -31, -45, -29],
        Int32[0, -196, -41, -91, -33],
        Int32[0, 50, 12, 0, 11],
        Int32[0, 120, 23, 68, 17],
        Int32[0, -174, -36, -69, -31],
        Int32[0, 81, 27, 4, 44],
        Int32[0, 149, 15, 1, 51],
        Int32[0, -35, 14, -10, 19],
        Int32[0, -97, -25, -31, -16],
        Int32[0, -91, -20, -46, -14],
        Int32[0, -41, 1, -29, -6]
    )),
    st2 = StructVector((
        Int32[0, 28, 35, 67, 15],
        Int32[0, -262, -30, -41, 3],
        Int32[0, -291, -68, -109, -13],
        Int32[0, 115, -2, -14, -10],
        Int32[0, 160, 51, 88, 14],
        Int32[0, -278, -50, -76, -4],
        Int32[0, 166, 21, 18, 43],
        Int32[0, 254, 23, 29, 93],
        Int32[0, -79, 28, 13, 35],
        Int32[0, -157, 0, -15, -14],
        Int32[0, -139, -1, -31, -12],
        Int32[0, -63, 20, -17, 9]
    ))
))

file_qrs = "tab_qrs"
savetable(BinToml, "$file_qrs.toml", qrs, fs, colunits = [:timeindex, :timeindex], tabletype = "segments")
qrs1, meta1 = readtable(BinToml, "$file_qrs.toml") # types preserved
rm("$file_qrs.toml")
rm("$file_qrs.bin")

savetable(H5Format, "$file_qrs.h5", qrs, fs, colunits = [:timeindex, :timeindex], tabletype = "segments")
qrs2, meta2 = readtable(H5Format, "$file_qrs.h5") # types preserved
rm("$file_qrs.h5")

# hdr - events not available
# savetable("$file.hdr", BinHdr, qrs, fs, colunits = [:timeindex, :timeindex], tabletype = "segments")
# qrs1, meta1 = readtable(BinHdr, "$file_qrs.hdr")

@test isequal(qrs, qrs1)
@test isequal(qrs, qrs2)

# end # testset

# TODO: надо оставить только те файлы, которые нужны для тестов:
# file = joinpath(@__DIR__, "files/bintable/016997_highHR/QrsBndMerge.toml")
# file = joinpath(@__DIR__, "files/bintable/evQrsDetect.toml")
# file = joinpath(@__DIR__, "files/bintable/016997_highHR.hdr")
# file = joinpath(@__DIR__, "files/bintable/QSBoundExact.toml")
# file = joinpath(@__DIR__, "files/bintable/test_ver2.toml")

# h = FileUtils.readtomlheader(file)
