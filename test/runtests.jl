using TestItems
using TestItemRunner
@run_package_tests


@testitem "_" begin
    import Aqua
    Aqua.test_all(PlutoTables; ambiguities=false)
    Aqua.test_ambiguities(PlutoTables)

    import CompatHelperLocal as CHL
    CHL.@check()
end
