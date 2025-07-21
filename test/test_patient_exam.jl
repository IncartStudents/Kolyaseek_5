using Test
using FileUtils
using Dates
using Tables, StructArrays

xmlfile = joinpath(Base.@__DIR__, "files/ox112785.000/AlgResult.xml")
hdrfile = joinpath(Base.@__DIR__, "files/headers/utf-8-bom.hdr")
recordfile = joinpath(Base.@__DIR__, "files/bintable/016997_highHR.bin")
resultdir = joinpath(Base.@__DIR__, "files/bintable/016997_highHR")

patient1, exam1 = readxml_patient_exam(xmlfile)
patient2, exam2 = readhdr_patient_exam(hdrfile)
patient3, exam3 = readdir_patient_exam(recordfile, resultdir)

@test patient1.name === patient2.name === patient3.name # проверим хотя бы одно поле

@test isempty(exam1.channel_groups) # нет данных в xml
@test !isempty(exam2.channel_groups)
@test !isempty(exam3.channel_groups)

@test Set(exam2.leadset_list) == Set(exam3.leadset_list) # системы отведений одинаковые

# проверка записи расширенного хедера
dst = joinpath(Base.@__DIR__, "files/headers/utf-8-bom-v2.hdr")

h = readhdr(hdrfile)
patient, exam = readhdr_patient_exam(hdrfile)

FileUtils.savehdr_patient_exam(dst, h, patient, exam)

patient2, exam2 = readhdr_patient_exam(dst)

# проверим только те поля, которые пишем и читаем (всего полей, конечно, больше)
@test all(field -> getproperty(patient, field) == getproperty(patient2, field),
    (:name, :surname, :patronymic, :birthday, :sex, :height, :weight))

@test all(field -> getproperty(exam, field) == getproperty(exam2, field),
    (:monitor_num, :monitor_typ, :record_prog_id, :record_prog_version, :stimulus,
    :timestart, :timeinstall))

# проверка работы с полями стимулятора
src = joinpath(Base.@__DIR__, "files/headers/stim_old.hdr")
dst = joinpath(Base.@__DIR__, "files/headers/stim_new.hdr")

h = readhdr(src)
patient, exam = readhdr_patient_exam(src)

FileUtils.savehdr_patient_exam(dst, h, patient, exam)

_, exam1 = readhdr_patient_exam(dst)

@test exam.stimulus == exam1.stimulus
