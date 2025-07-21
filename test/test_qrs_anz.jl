using Test
using FileUtils
using Dates
using Tables, StructArrays

# read_qrs_anz - различные форматы QRS-компеков из файлов
# унифицированы по именам полей, но имеют разное их кол-во

xmlfile = joinpath(Base.@__DIR__, "files/ox112785.000/AlgResult.xml")
csvfile = joinpath(Base.@__DIR__, "files/physionet/1201/qrs_forms.csv")
binfile = joinpath(Base.@__DIR__, "files/physionet/1201/NameQRS.toml")

qrs1, meta1 = read_qrs_anz(AlgResultXml, xmlfile); # медленно - 0.25 сек
qrs2, meta2 = read_qrs_anz(MicroboxQrsCsv, csvfile);
qrs3, meta3 = read_qrs_anz(BinToml, binfile);

@test Tables.columnnames(qrs1) === (:timeQ, :timeS, :form, :prem,
    :timePstart, :timeTendmax, :RR_ms, :QS_ms, :PQ_ms, :QT_ms, :QTmask)

@test Tables.columnnames(qrs2) === (:timeQ, :timeS, :form, :prem, :class_id) # + RR_ms, QS_ms?

@test Tables.columnnames(qrs3) === (:timeQ, :timeS, :form, :prem, :class_id, :diag) # + RR_ms, QS_ms?
