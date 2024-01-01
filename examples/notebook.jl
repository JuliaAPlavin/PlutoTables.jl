### A Pluto.jl notebook ###
# v0.19.25

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

# ╔═╡ 64229c85-c53d-4b77-bf06-c7cf7908d83c
using PlutoTables

# ╔═╡ 534f8121-dfc6-4df4-8bae-11c20f28424c
# using AccessorsExtra

# ╔═╡ f9b4544e-a767-4b84-9fdb-87cf0d4b1ed9
# using PlutoUI

# ╔═╡ 78203cc9-5db2-4a1b-ae7a-477d7ae458d9
# using InterferometricModels

# ╔═╡ 956329b7-b96d-4a3b-8324-aeb2f2c52195
# using Unitful, UnitfulAstro, UnitfulAngles

# ╔═╡ e1c7baa6-9477-4325-bcb3-a2d2126612d5
# using StaticArrays

# ╔═╡ 87d6e145-c147-4c89-bb22-c6c0f6ae5597
# using LinearAlgebra: norm

# ╔═╡ b2b80a68-cd1b-4a71-8b78-84d1d7b54172
struct SpiralOnCone{T}
	opening_angle::T
	viewing_angle::T
	turn_length::T
	starting_phase::T
end

# ╔═╡ 4f61bd17-264e-437d-a732-7c3fa76951fc
s = SpiralOnCone(deg2rad(1), deg2rad(5), 50., 0.)

# ╔═╡ ec7593c9-519d-41e6-ad01-e55a5d28f5fe
@bind spir ColumnInput(s, (
	rad2deg ∘ @optics(_.opening_angle, _.viewing_angle) => Slider(0.1:0.1:10, show_value=true),
	@optic(_.turn_length) => Slider(0:1.:150, show_value=true),
))

# ╔═╡ 705651fa-97a8-47c2-8fb3-6673feb541d3
spir

# ╔═╡ d6b97ac6-7e18-4f5d-a7ac-b11424e998dd
@bind spirals ItemsRowsInput((s,s,s), keyed(∗), (
	@optic(_.opening_angle |> rad2deg) => Slider(0.1:0.1:10, show_value=true),
	@optic(_.viewing_angle |> rad2deg) => Slider(0.1:0.1:10, show_value=true),
	@optic(_.turn_length) => Slider(0:1.:150, show_value=true),
	@optic(_.starting_phase |> rad2deg) => Slider(-180:5.:180, show_value=true),
))

# ╔═╡ 075c6a63-37d4-4f4a-a90d-008077e70d52
mod₀ = MultiComponentModel((
	CircularGaussian(flux=1.0u"Jy", σ=0.1u"mas", coords=SVector(0, 0.03)u"mas"),
	CircularGaussian(flux=0.7u"Jy", σ=0.3u"mas", coords=SVector(0, 2.)u"mas"),
	CircularGaussian(flux=0.2u"Jy", σ=0.7u"mas", coords=SVector(0, 5.)u"mas"),
))

# ╔═╡ 2fbff007-f984-4b67-a734-a4bb94fba078
@bind mod ColumnInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 1793c3bd-9eed-4f8c-bec6-0e4f72cb1ab0
RowInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 1de33737-5e14-4681-81b7-12c15f3d1a8f
@bind mod_ ItemsRowsInput(mod₀, (@optic components(_) |> keyed(∗)), (
	(@optic flux(_) |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic _.σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
	(@optic coords(_)[∗] |> ustrip(u"mas", _)) => Slider(-3:0.1:5, show_value=true),
))

# ╔═╡ a207d5c6-3fd0-470d-a651-1671e8d1304d
mod_

# ╔═╡ 7318e887-13ab-4793-a12a-21b60916cdd4
maxuv = 1e8

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

# ╔═╡ 2fb3bb4a-935f-469f-862a-fbdc016b3551
RowInput(mod₀, (
	(@optic components(_)[1] |> flux |> ustrip(u"Jy", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗] |> flux |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic components(_)[1].σ |> ustrip(u"mas", _)) => Scrubbable(NaN),
	(@optic components(_)[2:3][∗].σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
))

# ╔═╡ 59dd0471-041c-404b-87fe-5612803d6b23


# ╔═╡ a6f925a7-1f83-481a-9013-46d840e1689b
@bind cuv ColumnInput(SVector{2}, (
	norm => Slider(0:0.2e7:maxuv, default=maxuv/2, show_value=true),
	@optic(atan(_...) |> rad2deg) => Slider(-180:15:180, default=0, show_value=true)
))

# ╔═╡ 5ba9e31d-e34b-4be5-bfeb-b2e75def8895
cuv

# ╔═╡ 32aa5602-4950-4aa7-872d-ee4b4f5b10c4


# ╔═╡ 4296e025-8d17-4b64-8820-30b3b3c04823
ColumnInput(mod₀, (
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

# ╔═╡ 4263d5c8-3034-47a0-9bca-a2cf0f8a4dc4
@bind modc ItemsColumnsInput(mod₀, (@optic components(_) |> keyed(∗)), (
	(@optic flux(_) |> ustrip(u"Jy", _)) => Slider(0:0.1:1, show_value=true),
	(@optic _.σ |> ustrip(u"mas", _)) => Slider(0:0.1:1, show_value=true),
	(@optic coords(_)[∗] |> ustrip(u"mas", _)) => Slider(-3:0.1:5, show_value=true),
))

# ╔═╡ 52126650-561e-4083-8cb3-60fbd84f43e6
modc

# ╔═╡ Cell order:
# ╠═64229c85-c53d-4b77-bf06-c7cf7908d83c
# ╠═534f8121-dfc6-4df4-8bae-11c20f28424c
# ╠═f9b4544e-a767-4b84-9fdb-87cf0d4b1ed9
# ╠═78203cc9-5db2-4a1b-ae7a-477d7ae458d9
# ╠═956329b7-b96d-4a3b-8324-aeb2f2c52195
# ╠═e1c7baa6-9477-4325-bcb3-a2d2126612d5
# ╠═87d6e145-c147-4c89-bb22-c6c0f6ae5597
# ╠═b2b80a68-cd1b-4a71-8b78-84d1d7b54172
# ╠═4f61bd17-264e-437d-a732-7c3fa76951fc
# ╠═ec7593c9-519d-41e6-ad01-e55a5d28f5fe
# ╠═705651fa-97a8-47c2-8fb3-6673feb541d3
# ╠═d6b97ac6-7e18-4f5d-a7ac-b11424e998dd
# ╠═075c6a63-37d4-4f4a-a90d-008077e70d52
# ╠═2fbff007-f984-4b67-a734-a4bb94fba078
# ╠═1793c3bd-9eed-4f8c-bec6-0e4f72cb1ab0
# ╠═1de33737-5e14-4681-81b7-12c15f3d1a8f
# ╠═a207d5c6-3fd0-470d-a651-1671e8d1304d
# ╠═7318e887-13ab-4793-a12a-21b60916cdd4
# ╠═9855c5a0-0084-444e-82b9-919716ec62d9
# ╠═18ed596b-d25f-4b3e-968b-051c639de4ac
# ╠═1d3583db-2a25-438f-a77a-21c2db51ac6d
# ╠═2fb3bb4a-935f-469f-862a-fbdc016b3551
# ╠═59dd0471-041c-404b-87fe-5612803d6b23
# ╠═a6f925a7-1f83-481a-9013-46d840e1689b
# ╠═5ba9e31d-e34b-4be5-bfeb-b2e75def8895
# ╠═32aa5602-4950-4aa7-872d-ee4b4f5b10c4
# ╠═4296e025-8d17-4b64-8820-30b3b3c04823
# ╠═2d0b2c37-a76a-48be-ad1b-ef846be4dcc8
# ╠═21b38285-b3fc-40bb-ace7-312a1fa7c371
# ╠═4263d5c8-3034-47a0-9bca-a2cf0f8a4dc4
# ╠═52126650-561e-4083-8cb3-60fbd84f43e6
