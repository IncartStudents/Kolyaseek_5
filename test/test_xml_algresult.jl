using Test
using FileUtils
using Dates
using Tables, StructArrays

#пример использльзования функции
xmlfile = joinpath(Base.@__DIR__, "files/ox112785.000/AlgResult.xml")
xmldata = readxml_dict(xmlfile)

qrs, meta = readxml_pqrst_anz(xmlfile)

r, arr = readxml_rhythms_arrs(xmlfile)

@test 1 === 1

# ===================
# прежде чем писать тесты,
# надо упорядочить функции чтения QRS из XML

# # 1) readxml_pqrst_anz = readxml_qsparams = read_analyzer_xml = getqrs_algresult = read_data_anz_xml = get_qs_stdqrs_algresult
# # HotBox для конвертации в формы ГОСТ-47
# timeQ, timeS, form_anz, prem, ts, fs = read_analyzer_xml(xmlfile) # readxml_qsparams, но: Symbol(form), "_p$prem"
# # AlgCompare, внутри read_data_anz_xml
# qrs, timestart, freq = getqrs_algresult(xmlfile) # readxml_qsparams + поле RR с учетом Z
# DataFrame(qrs) # timeQ timeS form_id RR

# # 2) нигде толком не используется
# qs, timestart, freq = readxml_qs(xmlfile)
# DataFrame(qs) # Q S form
# # нигде толком не используется
# qs_, std_qrs_, timestart, freq = get_qs_stdqrs_algresult(xmlfile)
# DataFrame(qs_) # timeQ timeS form_id width RR
# DataFrame(std_qrs_) # timeQ timeS form_id timeTendmax timePstart


# 3) readcsv_qrs_microbox: read_analyzer_csv = read_data_anz_csv
# HotBox для чтения результатов микробокса в qrs_forms.csv + template_form.csv
# timeQ, timeS, form_anz, prem, tg

# 4) readbin_qrs_microbox: read_data_anz_bin

# xmlnode2dict

# ====================

# xml_doc = FileUtils.readxml(xmlfile)
# get_rhythms(xml_doc)

# qsparams, timestart, freq = readxml_qsparams(xmlfile) # TestGui, read_analyzer_csv
# DataFrame(qsparams) # Q S form prem QTs QTMasks PQs (колонки типа Any!)

"""
AlgCompare

Как было:
read_data
    dataname: QsAnz / "qs_anz"
        (H) read_analyzer_csv = qrs_forms.csv (Q S class_id form prem) + template_form.csv
        read_data_anz_csv = qrs_forms.csv (Q S class_id form prem) + template_form.csv + labels_anz2gost + пустые AF VF (pos, form, AF, VF)
        (H) read_analyzer_xml = readxml_qsparams + _p (timeQ, timeS, form_anz, prem)
        read_data_anz_xml = getqrs_algresult + labels_anz2gost + пустые AF VF (pos, form, AF, VF)
        read_data_anz_bin = (NameQrs)*.bin & Prematurity.bin (pos, form_anz, class_id) + template_form.csv + labels_anz2gost + пустые AF VF (pos, form, AF, VF)
    dataname: BeatPhysionet / "beat_physionet"
        read_data = read_physionet (pos, anntype, AF, VF) + labels_physionet2gost (pos, form, AF, VF)

Как надо:

readcsv_qrs_microbox   = (timeQ, timeS, form, prem) qrs_forms.csv + template_form.csv
readxml_pqrst_anz = (timeQ, timeS, form, prem, timePstart, timeTendmax, RR_ms, QS_ms, PQ_ms, QT_ms, QTmask,)
readbin_qrs_microbox   = (timeQ, timeS, form, prem, class_id) (NameQrs)*.bin + Prematurity.bin + template_form.csv
Physionet.read_ann = (pos, anntype, comments)

read_gost47 = (pos, anntype, AF, VF) ::F + labels_F2gost + AF VF - брать из ритмов?

read_data
    dataname: QsAnz / "qs_anz" (мин 4 поля)
        readcsv_qrs_microbox   = (timeQ, timeS, form, prem) qrs_forms.csv + template_form.csv || + labels_anz2gost + пустые AF VF (pos, form, AF, VF)
        readxml_pqrst_anz = (timeQ, timeS, form, prem, timePstart, timeTendmax, RR_ms, QS_ms, PQ_ms, QT_ms, QTmask,) || + labels_anz2gost + пустые AF VF (pos, form, AF, VF)
        readbin_qrs_microbox   = (timeQ, timeS, form, prem, class_id) (NameQrs)*.bin + Prematurity.bin || + template_form.csv + labels_anz2gost + пустые AF VF (pos, form, AF, VF)
    dataname: BeatPhysionet / "beat_physionet"
        read_data = read_physionet (pos, anntype, AF, VF) + labels_physionet2gost (pos, form, AF, VF)
        marks, meta = Physionet.read_ann
"""
