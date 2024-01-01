### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 534f8121-dfc6-4df4-8bae-11c20f28424c
using AccessorsExtra

# ╔═╡ f9b4544e-a767-4b84-9fdb-87cf0d4b1ed9
using PlutoUI

# ╔═╡ 78203cc9-5db2-4a1b-ae7a-477d7ae458d9
using InterferometricModels

# ╔═╡ 956329b7-b96d-4a3b-8324-aeb2f2c52195
using UnitfulAstro, UnitfulAngles

# ╔═╡ e1c7baa6-9477-4325-bcb3-a2d2126612d5
using StaticArrays

# ╔═╡ 87d6e145-c147-4c89-bb22-c6c0f6ae5597
using LinearAlgebra: norm

# ╔═╡ 0503b39f-f4d9-4633-89a0-73aa4aa71960
using Unitful

# ╔═╡ fd452340-15fb-490c-ad07-1fe5de5d339d
using DataPipes

# ╔═╡ 75939b8d-5c2f-4200-9622-13bfe0daca30
using HypertextLiteral

# ╔═╡ f094c093-f3c7-492a-b241-9f523f3f38da
using FlexiMaps: flatmap

# ╔═╡ f5e65103-2e03-48ea-9a05-2268929a10d6
using CompositionsBase

# ╔═╡ b2b80a68-cd1b-4a71-8b78-84d1d7b54172
struct SpiralOnCone{T}
	opening_angle::T
	viewing_angle::T
	turn_length::T
	starting_phase::T
end

# ╔═╡ 4f61bd17-264e-437d-a732-7c3fa76951fc
s = SpiralOnCone(deg2rad(1), deg2rad(5), 50., 0.)

# ╔═╡ 075c6a63-37d4-4f4a-a90d-008077e70d52
mod₀ = MultiComponentModel((
	CircularGaussian(flux=1.0u"Jy", σ=0.1u"mas", coords=SVector(0, 0.03)u"mas"),
	CircularGaussian(flux=0.7u"Jy", σ=0.3u"mas", coords=SVector(0, 2.)u"mas"),
	CircularGaussian(flux=0.2u"Jy", σ=0.7u"mas", coords=SVector(0, 5.)u"mas"),
))

# ╔═╡ 7318e887-13ab-4793-a12a-21b60916cdd4
maxuv = 1e8

# ╔═╡ 5be97943-774e-4831-819c-1fd5a6db7a0f


# ╔═╡ 7206de10-c0fa-4f4e-8260-57c09b59af94


# ╔═╡ 6285c7b0-0ef4-4b0e-aa3a-be0a0119ba62


# ╔═╡ 34932986-aa3d-44dc-8215-d48b89b1d7cc
_split_unit(o::Base.Fix1{typeof(ustrip)}) = (identity, string(o.x))

# ╔═╡ 664443cf-2980-4779-80f4-67c618ff70e9


# ╔═╡ a1dfe4cc-62fc-48b9-a76a-6868b0760f37


# ╔═╡ 90f75cb3-358e-4277-87d7-3cf6d3c7e2db


# ╔═╡ 59dd0471-041c-404b-87fe-5612803d6b23
_optic_short_str(o) = replace(sprint(print, o; context=:compact => true), r"\(@optic ([^)]+)\)" => s"\1")

# ╔═╡ 5dbac3bc-969f-4fb8-83c6-71c046f4813f
begin
	_unit_to_html(::Nothing) = ""
	_unit_to_html(ustr::String) = "($ustr)"
end

# ╔═╡ 32aa5602-4950-4aa7-872d-ee4b4f5b10c4
begin
	_from_wspec(spec::NamedTuple) = spec
	_from_wspec(widget) = (; widget)
end

# ╔═╡ be04bb23-db3a-4051-9d85-dbf54b4e6b3d


# ╔═╡ e72da5f7-4cb4-45e3-93e2-b892214489c5
struct RowSpan{T}
	value::T
	rowspan::Int
end

# ╔═╡ 34adef59-13b9-423e-9815-693cea6e69a8
struct ColSpan{T}
	value::T
	colspan::Int
end

# ╔═╡ 10837c14-9624-493e-9097-a87e839f1d79
begin
	_to_td(::Nothing) = nothing
	_to_td(x) = @htl("<td>$x</td>")
	_to_td(x::RowSpan{Nothing}) = nothing
	_to_td(x::RowSpan) = @htl("<td rowspan=$(x.rowspan)>$(x.value)</td>")
	_to_td(x::ColSpan{Nothing}) = nothing
	_to_td(x::ColSpan) = @htl("<td colspan=$(x.colspan)>$(x.value)</td>")
end

# ╔═╡ 8fe58e6b-862a-4418-875f-b724c76ed32c
_table_html(colheads, rowheads, rows) = @htl("""
<table>
<thead style="text-align: center">
	$(map(colheads) do ch_row
		@htl("<tr>
			$(map(_to_td, ch_row))
		</tr>")
	end)
</thead>
<tbody>
	$(map(enumerate(rows)) do (irow, row)
		@htl("""
		<tr>
			$(map(rh -> _to_td(rh[irow]), rowheads))
			$(map(_to_td, Tuple(row)))
		</tr>
		""")
	end)
</tbody>
</table>
""")

# ╔═╡ dbb920f7-4a77-451f-bed5-9c0f28d03db4


# ╔═╡ edce8c8c-39df-4a30-9acc-9366293b1b4f


# ╔═╡ b20281c2-a337-4037-81f1-93484bcc1ecc


# ╔═╡ 9d64a7a6-4524-4caf-91ae-653ad2071c14


# ╔═╡ 63a6fb09-9796-4c93-ac5b-0a23b87d6f15


# ╔═╡ fadc6f4b-c83c-499f-880e-c6f04c1d7ea6


# ╔═╡ 4823662d-1269-4273-8f61-5bbb9a2068cd
begin
	_stripidentity(o::ComposedFunction) = @delete decompose(o) |> filter(==(identity))
	_stripidentity(o) = o
end

# ╔═╡ 714f81ba-fdac-11ed-2893-2fe1b698f886
begin
	_split_unit(o::typeof(rad2deg)) = (identity, "°")
	_split_unit(o) = (o, nothing)
	
	function _split_unit(o::ComposedFunction)
		oshow, unit = _split_unit(o.outer)
		(_stripidentity(oshow ∘ o.inner), unit)
	end
end

# ╔═╡ bd776d93-f56d-4f4f-a667-05aa9a0ca25e
_fullspec(optics, obj) = map(optics) do (optic, spec)
	oshow, unit = _split_unit(optic)
	(; optic, unit, label=_optic_short_str(oshow), nrow=length(getall(obj, optic)), _from_wspec(spec)...)
end

# ╔═╡ 8204c205-2286-4b2a-ac31-22279eacd269
_fullspec(optics) = map(optics) do (optic, spec)
	oshow, unit = _split_unit(optic)
	(; optic, unit, label=_optic_short_str(oshow), _from_wspec(spec)...)
end

# ╔═╡ 0b3e8007-b2eb-4611-a0b2-110930cc6a26
function ColumnInput(ctype::Type, optics)
	os_full = _fullspec(optics)
	itemshead = [["Optic"; "Unit"; "Value"]]
	optshead = [
		map(or -> or.label, os_full),
		map(or -> _unit_to_html(or.unit), os_full),
	]
	all(isnothing, optshead[2]) && deleteat!(only(itemshead), 2)
	@p PlutoUI.combine() do Child
		tbldata = [
			map(os_full) do or
				Child(or.widget)
			end
		] |> stack
		_table_html(itemshead, optshead, eachrow(tbldata))
	end |>
	PlutoUI.Experimental.transformed_value() do tup
		construct(ctype, (first.(optics) .=> tup)...)
	end
end

# ╔═╡ ea5ef953-d463-4b51-bbf5-d3dd4874ef68
function ItemsRowsInput(obj, itemsoptic, optics)
	items = getall(obj, itemsoptic)
	os_full = _fullspec(optics, stripcontext(first(items)))
	itemshead = [map(items) do kit
		kit isa AccessorsExtra.ValWithContext ? first(kit) : nothing
	end]
	optshead = [
		["Key"; flatmap(or -> Any[ColSpan(or.label, or.nrow); fill(nothing, or.nrow-1)], os_full)],
		[""; flatmap(or -> Any[ColSpan(_unit_to_html(or.unit), or.nrow); fill(nothing, or.nrow-1)], os_full)],
	]
	if any(isnothing, only(itemshead))
		@assert all(isnothing, only(itemshead))
		deleteat!(optshead[1], 1)
		deleteat!(optshead[2], 1)
	end
	@p PlutoUI.combine() do Child
		tbldata = map(items .|> stripcontext) do item
			flatmap(os_full) do or
				map(getall(item, or.optic) |> enumerate) do (i, b)
					Child(@set $(or.widget).default = b)
				end
			end
		end |> stack
		_table_html(optshead, itemshead, eachcol(tbldata))
	end |>
	PlutoUI.Experimental.transformed_value() do tup
		setall(obj, AccessorsExtra.concat(first.(optics)...) ∘ stripcontext(itemsoptic), tup)
	end
end

# ╔═╡ d6b97ac6-7e18-4f5d-a7ac-b11424e998dd
@bind spirals ItemsRowsInput((s,s,s), keyed(∗), (
	@optic(_.opening_angle |> rad2deg) => Slider(0.1:0.1:10, show_value=true),
	@optic(_.viewing_angle |> rad2deg) => Slider(0.1:0.1:10, show_value=true),
	@optic(_.turn_length) => Slider(0:1.:150, show_value=true),
	@optic(_.starting_phase |> rad2deg) => Slider(-180:5.:180, show_value=true),
))

# ╔═╡ 1de33737-5e14-4681-81b7-12c15f3d1a8f
@bind mod_ ItemsRowsInput(mod₀, (@optic components(_) |> keyed(∗)), (
	(@optic flux(_) |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic _.σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
	(@optic coords(_)[∗] |> ustrip(u"mas", _)) => Slider(-3:0.1:5, show_value=true),
))

# ╔═╡ a207d5c6-3fd0-470d-a651-1671e8d1304d
mod_

# ╔═╡ d0e8464f-de31-4e99-aaa6-b9397acfcae5
RowInput(obj, optics) = @p ItemsRowsInput(obj, identity, optics)

# ╔═╡ 1793c3bd-9eed-4f8c-bec6-0e4f72cb1ab0
RowInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 2fb3bb4a-935f-469f-862a-fbdc016b3551
RowInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 2d0b2c37-a76a-48be-ad1b-ef846be4dcc8
@bind modr ItemsRowsInput(mod₀, (@optic components(_) |> keyed(∗)), (
	(@optic flux(_) |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic _.σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
	(@optic coords(_)[∗] |> ustrip(u"mas", _)) => Slider(-3:0.1:5, show_value=true),
))

# ╔═╡ 21b38285-b3fc-40bb-ace7-312a1fa7c371
modr

# ╔═╡ 6c64c1a7-e0df-4870-aa12-6c0fd7ad029d
function ItemsColumnsInput(obj, itemsoptic, optics)
	items = getall(obj, itemsoptic)
	os_full = _fullspec(optics, stripcontext(first(items)))
	itemshead = [["Optic"; "Unit"; map(items) do kit
		kit isa AccessorsExtra.ValWithContext ? first(kit) : "Value"
	end |> collect]]
	optshead = [
		flatmap(or -> Any[RowSpan(or.label, or.nrow); fill(nothing, or.nrow-1)], os_full),
		flatmap(or -> Any[RowSpan(_unit_to_html(or.unit), or.nrow); fill(nothing, or.nrow-1)], os_full),
	]
	all(isnothing, optshead[2]) && deleteat!(only(itemshead), 2)
	@p PlutoUI.combine() do Child
		tbldata = map(items .|> stripcontext) do item
			flatmap(os_full) do or
				map(getall(item, or.optic) |> enumerate) do (i, b)
					Child(@set $(or.widget).default = b)
				end
			end
		end |> stack
		_table_html(itemshead, optshead, eachrow(tbldata))
	end |>
	PlutoUI.Experimental.transformed_value() do tup
		tup = vec(permutedims(reshape(collect(tup), (length(items), :)))) |> Tuple
		setall(obj, AccessorsExtra.concat(first.(optics)...) ∘ stripcontext(itemsoptic), tup)
	end
end

# ╔═╡ b00c05fb-50a2-4dad-b4d7-77afc4f0e7f8
ColumnInput(obj, optics) = @p ItemsColumnsInput(obj, identity, optics)

# ╔═╡ ec7593c9-519d-41e6-ad01-e55a5d28f5fe
@bind spir ColumnInput(s, (
	rad2deg ∘ @optics(_.opening_angle, _.viewing_angle) => Slider(0.1:0.1:10, show_value=true),
	@optic(_.turn_length) => Slider(0:1.:150, show_value=true),
))

# ╔═╡ 705651fa-97a8-47c2-8fb3-6673feb541d3
spir

# ╔═╡ 2fbff007-f984-4b67-a734-a4bb94fba078
@bind mod ColumnInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 9855c5a0-0084-444e-82b9-919716ec62d9
@bind uv ColumnInput(SVector{2}, (
	norm => Slider(0:0.2e7:maxuv, default=maxuv/2, show_value=true),
	@optic(atan(_...) |> rad2deg) => Slider(-180:15:180, default=0, show_value=true)
))

# ╔═╡ 18ed596b-d25f-4b3e-968b-051c639de4ac
ColumnInput(SVector(3e7, 0), (
	norm => Slider(0:0.2e7:1e8, show_value=true),
	@optic(atan(_...) |> rad2deg) => Slider(-180:15.:180, show_value=true)
))

# ╔═╡ 1d3583db-2a25-438f-a77a-21c2db51ac6d
ColumnInput(SVector(3e7, 0), (
	norm => Slider(0:0.2e7:1e8, show_value=true),
	@optic(atan(_...)) => Slider(-180:15.:180, show_value=true)
))

# ╔═╡ a6f925a7-1f83-481a-9013-46d840e1689b
@bind cuv ColumnInput(SVector{2}, (
	norm => Slider(0:0.2e7:maxuv, default=maxuv/2, show_value=true),
	@optic(atan(_...) |> rad2deg) => Slider(-180:15:180, default=0, show_value=true)
))

# ╔═╡ 5ba9e31d-e34b-4be5-bfeb-b2e75def8895
cuv

# ╔═╡ 4296e025-8d17-4b64-8820-30b3b3c04823
ColumnInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 4263d5c8-3034-47a0-9bca-a2cf0f8a4dc4
@bind modc ItemsColumnsInput(mod₀, (@optic components(_) |> keyed(∗)), (
	(@optic flux(_) |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic _.σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
	(@optic coords(_)[∗] |> ustrip(u"mas", _)) => Slider(-3:0.1:5, show_value=true),
))

# ╔═╡ 52126650-561e-4083-8cb3-60fbd84f43e6
modc

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AccessorsExtra = "33016aad-b69d-45be-9359-82a41f556fd4"
CompositionsBase = "a33af91c-f02d-484b-be07-31d278c5ca2b"
DataPipes = "02685ad9-2d12-40c3-9f73-c6aeda6a7ff5"
FlexiMaps = "6394faf6-06db-4fa8-b750-35ccc60383f7"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
InterferometricModels = "b395d269-c2ec-4df6-b679-36919ad600ca"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
UnitfulAngles = "6fb2a4bd-7999-5318-a3b2-8ad61056cd98"
UnitfulAstro = "6112ee07-acf9-5e0f-b108-d242c714bf9f"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "47e168e82b229aec279a75c0c0c8e53c771ad5e1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Accessors]]
deps = ["Compat", "CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "MacroTools", "Requires", "Test"]
git-tree-sha1 = "2b301c2388067d655fe5e4ca6d4aa53b61f895b4"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.31"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"

[[deps.AccessorsExtra]]
deps = ["Accessors", "CompositionsBase", "ConstructionBase", "DataPipes", "InverseFunctions", "Reexport"]
git-tree-sha1 = "c22406c1dbdcaeb50045a92db8b20b69b0a1c759"
uuid = "33016aad-b69d-45be-9359-82a41f556fd4"
version = "0.1.44"

    [deps.AccessorsExtra.extensions]
    DictionariesExt = "Dictionaries"
    DistributionsExt = "Distributions"
    DomainSetsExt = "DomainSets"
    StaticArraysExt = "StaticArrays"
    StructArraysExt = "StructArrays"
    TestExt = "Test"

    [deps.AccessorsExtra.weakdeps]
    Dictionaries = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    DomainSets = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.DataPipes]]
git-tree-sha1 = "3b4bc031d472fbcee3335ceadd85b399dfdd8006"
uuid = "02685ad9-2d12-40c3-9f73-c6aeda6a7ff5"
version = "0.3.8"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.FlexiMaps]]
deps = ["Accessors", "InverseFunctions"]
git-tree-sha1 = "e5a6fa9d8ee0dae4edc8c07212262b810e2aa570"
uuid = "6394faf6-06db-4fa8-b750-35ccc60383f7"
version = "0.1.14"

    [deps.FlexiMaps.extensions]
    DictionariesExt = "Dictionaries"
    StructArraysExt = "StructArrays"

    [deps.FlexiMaps.weakdeps]
    Dictionaries = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InterferometricModels]]
deps = ["Accessors", "AccessorsExtra", "IntervalSets", "LinearAlgebra", "StaticArrays", "Unitful", "UnitfulAstro"]
git-tree-sha1 = "0431cb6fa14409e829f0ae8f98175f97feb4e760"
uuid = "b395d269-c2ec-4df6-b679-36919ad600ca"
version = "0.1.10"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "16c0cc91853084cb5f58a78bd209513900206ce6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "6667aadd1cdee2c6cd068128b3d226ebc4fb0c67"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.9"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a5aef8d4a6e8d81f171b2bd4be5265b01384c74c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.10"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "259e206946c293698122f63e2b513a7c99a244e8"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "8982b3607a212b070a5e46eea83eb62b4744ae12"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.25"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "ba4aa36b2d5c98d6ed1f149da916b3ba46527b2b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.14.0"
weakdeps = ["InverseFunctions"]

    [deps.Unitful.extensions]
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.UnitfulAngles]]
deps = ["Dates", "Unitful"]
git-tree-sha1 = "d6cfdb6ddeb388af1aea38d2b9905fa014d92d98"
uuid = "6fb2a4bd-7999-5318-a3b2-8ad61056cd98"
version = "0.6.2"

[[deps.UnitfulAstro]]
deps = ["Unitful", "UnitfulAngles"]
git-tree-sha1 = "05adf5e3a3bd1038dd50ff6760cddd42380a7260"
uuid = "6112ee07-acf9-5e0f-b108-d242c714bf9f"
version = "1.2.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═534f8121-dfc6-4df4-8bae-11c20f28424c
# ╠═f9b4544e-a767-4b84-9fdb-87cf0d4b1ed9
# ╠═b2b80a68-cd1b-4a71-8b78-84d1d7b54172
# ╠═4f61bd17-264e-437d-a732-7c3fa76951fc
# ╠═ec7593c9-519d-41e6-ad01-e55a5d28f5fe
# ╠═705651fa-97a8-47c2-8fb3-6673feb541d3
# ╠═d6b97ac6-7e18-4f5d-a7ac-b11424e998dd
# ╠═78203cc9-5db2-4a1b-ae7a-477d7ae458d9
# ╠═956329b7-b96d-4a3b-8324-aeb2f2c52195
# ╠═e1c7baa6-9477-4325-bcb3-a2d2126612d5
# ╠═075c6a63-37d4-4f4a-a90d-008077e70d52
# ╠═2fbff007-f984-4b67-a734-a4bb94fba078
# ╠═1793c3bd-9eed-4f8c-bec6-0e4f72cb1ab0
# ╠═1de33737-5e14-4681-81b7-12c15f3d1a8f
# ╠═a207d5c6-3fd0-470d-a651-1671e8d1304d
# ╠═7318e887-13ab-4793-a12a-21b60916cdd4
# ╠═87d6e145-c147-4c89-bb22-c6c0f6ae5597
# ╠═9855c5a0-0084-444e-82b9-919716ec62d9
# ╠═18ed596b-d25f-4b3e-968b-051c639de4ac
# ╠═1d3583db-2a25-438f-a77a-21c2db51ac6d
# ╠═5be97943-774e-4831-819c-1fd5a6db7a0f
# ╠═7206de10-c0fa-4f4e-8260-57c09b59af94
# ╠═6285c7b0-0ef4-4b0e-aa3a-be0a0119ba62
# ╠═0503b39f-f4d9-4633-89a0-73aa4aa71960
# ╠═34932986-aa3d-44dc-8215-d48b89b1d7cc
# ╠═714f81ba-fdac-11ed-2893-2fe1b698f886
# ╠═664443cf-2980-4779-80f4-67c618ff70e9
# ╠═a1dfe4cc-62fc-48b9-a76a-6868b0760f37
# ╠═90f75cb3-358e-4277-87d7-3cf6d3c7e2db
# ╠═2fb3bb4a-935f-469f-862a-fbdc016b3551
# ╠═fd452340-15fb-490c-ad07-1fe5de5d339d
# ╠═75939b8d-5c2f-4200-9622-13bfe0daca30
# ╠═f094c093-f3c7-492a-b241-9f523f3f38da
# ╠═59dd0471-041c-404b-87fe-5612803d6b23
# ╠═5dbac3bc-969f-4fb8-83c6-71c046f4813f
# ╠═bd776d93-f56d-4f4f-a667-05aa9a0ca25e
# ╠═8204c205-2286-4b2a-ac31-22279eacd269
# ╠═d0e8464f-de31-4e99-aaa6-b9397acfcae5
# ╠═b00c05fb-50a2-4dad-b4d7-77afc4f0e7f8
# ╠═a6f925a7-1f83-481a-9013-46d840e1689b
# ╠═5ba9e31d-e34b-4be5-bfeb-b2e75def8895
# ╠═32aa5602-4950-4aa7-872d-ee4b4f5b10c4
# ╠═be04bb23-db3a-4051-9d85-dbf54b4e6b3d
# ╠═e72da5f7-4cb4-45e3-93e2-b892214489c5
# ╠═34adef59-13b9-423e-9815-693cea6e69a8
# ╠═10837c14-9624-493e-9097-a87e839f1d79
# ╠═8fe58e6b-862a-4418-875f-b724c76ed32c
# ╠═dbb920f7-4a77-451f-bed5-9c0f28d03db4
# ╠═edce8c8c-39df-4a30-9acc-9366293b1b4f
# ╠═b20281c2-a337-4037-81f1-93484bcc1ecc
# ╠═9d64a7a6-4524-4caf-91ae-653ad2071c14
# ╠═63a6fb09-9796-4c93-ac5b-0a23b87d6f15
# ╠═4296e025-8d17-4b64-8820-30b3b3c04823
# ╠═2d0b2c37-a76a-48be-ad1b-ef846be4dcc8
# ╠═21b38285-b3fc-40bb-ace7-312a1fa7c371
# ╠═4263d5c8-3034-47a0-9bca-a2cf0f8a4dc4
# ╠═52126650-561e-4083-8cb3-60fbd84f43e6
# ╠═0b3e8007-b2eb-4611-a0b2-110930cc6a26
# ╠═ea5ef953-d463-4b51-bbf5-d3dd4874ef68
# ╠═6c64c1a7-e0df-4870-aa12-6c0fd7ad029d
# ╠═fadc6f4b-c83c-499f-880e-c6f04c1d7ea6
# ╠═f5e65103-2e03-48ea-9a05-2268929a10d6
# ╠═4823662d-1269-4273-8f61-5bbb9a2068cd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
