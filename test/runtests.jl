#using SafeTestsets
using TestItems
@safetestset "test_sample_tables.jl" begin include("test_sample_tables.jl") end

# на винде у раннера ошибка
# test_physionet.jl: Test Failed at C:\actions-runner\_work\FileUtils.jl\FileUtils.jl\test\test_physionet.jl:40
@safetestset "test_physionet.jl" begin include("test_physionet.jl") end

@safetestset "test_toml.jl" begin include("test_toml.jl") end
@safetestset "test_hdr.jl" begin include("test_hdr.jl") end
@safetestset "test_xml_algresult.jl" begin include("test_xml_algresult.jl") end
@safetestset "test_gost47.jl" begin include("test_gost47.jl") end
@safetestset "test_qrs_anz.jl" begin include("test_qrs_anz.jl") end
@safetestset "test_patient_exam.jl" begin include("test_patient_exam.jl") end
@safetestset "test_box51.jl" begin include("test_box51.jl") end
@safetestset "test_stdmkp.jl" begin include("test_stdmkp.jl") end
# TODO
# @safetestset "test_dat.jl" begin include("test_dat.jl") end
# TODO: залить тестовые файлы из gitignore !!!

@testitem "test_samplers" begin include("test_samplers.jl") end
@testitem "test_join" begin include("test_join.jl") end
@testitem "test_bins" begin include("test_bins.jl") end
@testitem "test_heartrate" begin include("test_heartrate.jl") end

