using Test
using FileUtils

# @testset "physionet - read dat, ann, convert" begin

file_physio = joinpath(@__DIR__(), "files/physionet/1201")

cols, h = readcols(PhysionetDat, "$file_physio.dat") # types preserved

sig, meta = readtable(PhysionetDat, "$file_physio.dat") # types preserved
h = readheader("$file_physio.hea")
Physionet.convert_samples_dat2binhdr("$file_physio.dat")
sig1, meta1 = readtable(BinHdr, "$file_physio.hdr")
h1 = readheader("$file_physio.hdr")
rm("$file_physio.hdr")
rm("$file_physio.bin")

@test sig == sig1
@test meta == meta1
# isequal(h, h1) # нет реализации с разбором полей

# !!! пока не переведено в таблицу readtable(PhysionetAnn, physio_file) # types preserved
marks, meta = Physionet.read_ann("$file_physio.atr") # types preserved
Physionet.convert_ann_bin2csv("$file_physio.atr")
marks1, meta1 = Physionet.readcsv_ann("$file_physio.csv") # types preserved
rm("$file_physio.csv")

# TODO: подобрать файл, где есть: AF, VF, excluded
AF, VF, excluded = Physionet.get_segments_AF_VF_excluded(
    marks.pos, marks.anntype, marks.comments, meta.fs)

@test isequal(marks, marks1)
@test isequal(meta, meta1)

# унифицированный синтаксис между сигналами и метками:
sig2, meta2_s = readtable(PhysionetDat, "$file_physio.dat")
marks2_, meta2_m = readtable(PhysionetAnn, "$file_physio.atr")

@test isequal(sig, sig2)
@test isequal(marks, marks2_)

# end # testset

# переименования:
# convert_physionet_dat2bin -> convert_samples_dat2binhdr
# convert_physionet_ann2csv -> convert_ann_bin2csv
# read_physionet_ann -> readbin_ann
# read_physionet_csv -> readcsv_ann
# read_physionet -> read_ann
# read_physionet_samples -> read_samples

# унификация:
# read_ann -> readtable
# read_samples -> readtable
# кроме readcols и readheader - они НЕ унифицированы
