using TestItems
using TestItemRunner
@run_package_tests


@testitem "units" begin
    using PlutoTables: _split_unit
    using AccessorsExtra
    using Unitful

    @test _split_unit(@o ustrip(u"m", _)) === (identity, "m")
    @test _split_unit(@o _[∗] |> angle |> rad2deg) === ((@o _[∗] |> angle), "°")
    @test _split_unit(@o _.comps[∗].scale |> ustrip(u"m", _)) === ((@o _.comps[∗].scale), "m")
    @test _split_unit(@o _.comps |> enumerated(∗) |> _.scale |> ustrip(u"m", _)) === ((@o _.comps |> enumerated(∗) |> _.scale), "m")
    @test _split_unit((@o _.comps[∗].scale |> ustrip(u"m", _)) |> enumerated) === ((@o _.comps[∗].scale) |> enumerated, "m")
end

@testitem "ColumnInput construct" begin
    using PlutoUI
    import AbstractPlutoDingetjes: Bonds

    w = ColumnInput(ComplexF64, (
        abs => Slider(0:0.2e7:1e8, default=5e7, show_value=true),
        angle => Slider(-180:15:180, default=0, show_value=true)
    ))
    @test Bonds.initial_value(w) === 5e7 + 0im
    w = ColumnInput(ComplexF64, (
        abs => Slider(0:0.2e7:1e8, default=5e7, show_value=true),
        rad2deg ∘ angle => Slider(-180:15:180, default=0, show_value=true)
    ))
    @test Bonds.initial_value(w) === 5e7 + 0im
end

@testitem "Row and ColumnInput modify" begin
    using PlutoUI
    using Unitful
    using AccessorsExtra
    import AbstractPlutoDingetjes: Bonds

    for IT in (ColumnInput, RowInput)
        w = IT(3e7 - 5e7im, (
            abs => Slider(0:0.2e7:1e8, show_value=true),
            angle => Slider(-180:15.:180, show_value=true)
        ))
        @test Bonds.initial_value(w) ≈ 3e7 - 5e7im

        w = IT(3e7 - 5e7im, (
            abs => Slider(0:0.2e7:1e8, show_value=true),
            @optic(angle(_) |> ustrip(u"°", _)) => Slider(-180:15.:180, show_value=true)
        ))
        @test Bonds.initial_value(w) ≈ 3e7 - 5e7im

        w = IT(3e7 - 5e7im, (
            Properties() => Scrubbable(NaN),
        ))
        @test Bonds.initial_value(w) ≈ 3e7 - 5e7im
        w = IT(3e7 - 5e7im, (
            keyed(Properties()) => Scrubbable(NaN),
        ))
        @test Bonds.initial_value(w) ≈ 3e7 - 5e7im

        w = IT(3e7 - 5e7im, ())
        @test Bonds.initial_value(w) ≈ 3e7 - 5e7im
    end
end

@testitem "Items(Rows and Columns)Input" begin
    using PlutoUI
    using Unitful
    using AccessorsExtra
    import AbstractPlutoDingetjes: Bonds

    ≈ₜ(x::T, y::T) where {T} = all(x .≈ y)

    @testset for IT in (ItemsRowsInput, ItemsColumnsInput)
        @testset for itemsoptic in (Elements(), keyed(Elements()), Properties(), keyed(Properties()), @optics(_[1], _[2]))
            w = IT((
                    1+2im,
                    3-4im,
                    5.5+6.5im,    
                ), itemsoptic, (
                    abs => Slider(0:0.2e7:1e8, show_value=true),
                    rad2deg ∘ angle => Slider(-180:15.:180, show_value=true)
            ))
            @test Bonds.initial_value(w) ≈ₜ (
                1.0+2im,
                3.0-4im,
                5.5+6.5im,    
            )

            w = IT((
                    1.0+2im,
                    3.0-4im,
                    5.5+6.5im,    
                ), itemsoptic, ())
            @test Bonds.initial_value(w) ≈ₜ (
                1.0+2im,
                3.0-4im,
                5.5+6.5im,    
            )

            # w = IT((), itemsoptic, ())
            # @test Bonds.initial_value(w) ≈ₜ ()
        end
        @testset for itemsoptic in (Elements(), keyed(Elements()), @optics(_[1], _[3]))
            w = IT([
                    1+2im,
                    3-4im,
                    5.5+6.5im,    
                ], itemsoptic, (
                    abs => Slider(0:0.2e7:1e8, show_value=true),
                    rad2deg ∘ angle => Slider(-180:15.:180, show_value=true)
            ))
            @test Bonds.initial_value(w) ≈ₜ [
                1+2im,
                3-4im,
                5.5+6.5im,    
            ]
        end
    end
end


@testitem "_" begin
    import Aqua
    Aqua.test_all(PlutoTables; ambiguities=false)
    Aqua.test_ambiguities(PlutoTables)

    import CompatHelperLocal as CHL
    CHL.@check()
end
