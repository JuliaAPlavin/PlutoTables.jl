### A Pluto.jl notebook ###
# v0.19.38

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

# ╔═╡ f9b4544e-a767-4b84-9fdb-87cf0d4b1ed9
using PlutoUIExtra

# ╔═╡ 0b8514f0-953c-49ea-8dae-67eabd30432c
using IntervalSets

# ╔═╡ 956329b7-b96d-4a3b-8324-aeb2f2c52195
using Unitful

# ╔═╡ 534f8121-dfc6-4df4-8bae-11c20f28424c
begin
using AccessorsExtra
# XXX: will be upstreamed
Accessors.set(obj, ::typeof(ustrip), val) = val * unit(obj)
end

# ╔═╡ e1c7baa6-9477-4325-bcb3-a2d2126612d5
using StaticArrays

# ╔═╡ 87d6e145-c147-4c89-bb22-c6c0f6ae5597
using LinearAlgebra: norm

# ╔═╡ 0e0ca714-0b17-4406-b43a-0a1e3e8eef96
md"""
Import `PlutoTables` and other useful packages:
"""

# ╔═╡ e82cad05-8438-41c6-9017-225dcd13b90e
# begin
# 	using Revise
# 	import Pkg
# 	eval(:(Pkg.develop(path="..")))
# 	using PlutoTables
# end

# ╔═╡ 90bb0c1a-0c92-4d7b-90bf-d0fdce2d359f


# ╔═╡ d037507e-dc38-426d-9973-e9919bdafa40
md"""
Define a nested struct that we'll create tabular UI for. This is standard Julia code, nothing specific to `PlutoTables`.
"""

# ╔═╡ 1d6dc40b-9a40-432b-93c0-daa344d8de3e
begin
	struct ExpModel{A,B}
		scale::A
		shift::B
	end
	
	struct SumModel{T <: Tuple}
		comps::T
	end
	
	(m::ExpModel)(x) = m.scale * exp(-(x - m.shift)^2)
	(m::SumModel)(x) = sum(c -> c(x), m.comps)
end

# ╔═╡ 2044c277-0636-4bd4-a6d7-b349cb9012cd
md"""
Create an instance of this struct:
"""

# ╔═╡ 746f5643-0d92-4ccf-af66-175806c56c03
mod₀ = SumModel((
	ExpModel(2., 5.),
	ExpModel(0.5, 2.),
	ExpModel(0.5, 8.),
))

# ╔═╡ 7d318069-96bc-48ef-a98e-487e7ce02b17
md"""
Now, let's see some examples of `PlutoTables` UIs and layouts to modify this object.

Target values are specified as `Accessors` optics, and each is associated with a `PlutoUI` input element using the `Pair` syntax: `optic => input`.

Note how the syntax is similar to optimization problem specifications in the `AccessibleOptimization` package.
"""

# ╔═╡ d6d49311-ef4f-4bde-8064-71e9dc20812f
md"""
- Edit some specific values of interest:
"""

# ╔═╡ 23aa9375-b404-428b-8158-8f1b779c5eef
@bind mod1 ColumnInput(mod₀, (
	(@o _.comps[1].scale) => Slider(0:5., show_value=true),
	(@o _.comps[1].shift) => Slider(0:5., show_value=true),
	(@o _.comps[3].shift) => Slider(0:10., show_value=true),
))

# ╔═╡ 87182d19-9705-44ca-8c4f-591c1510b179
mod1

# ╔═╡ b180cc61-de6e-4546-a97e-dbb5cfc1d4e4
md"""
- Edit all scales and shifts:
"""

# ╔═╡ 6b12af31-791a-4919-9de1-5a35202cb2f7
@bind mod2 ColumnInput(mod₀, (
	(@o _.comps[∗].scale) => Slider(0..5),
	(@o _.comps[∗].shift) => Slider(0..10),
))

# ╔═╡ ca01b0d5-0a06-4ac2-846d-c9478e964295
mod2

# ╔═╡ b8dbe2b5-75ab-4744-918f-cb4c940e7638
md"""
- Show numbers, keys, or any other information using context-optics from `AccessorsExtra`:
"""

# ╔═╡ bfa7c1a2-9259-4aa4-b69c-c982674ccc0d
@bind mod2k ColumnInput(mod₀, (
	(@o _.comps |> keyed(∗) |> _.scale) => Slider(0:0.1:5, show_value=true),
	(@o _.comps[∗].shift) => Slider(0.0:10, show_value=true),
))

# ╔═╡ 314c256e-c695-4e8a-8641-402cb733f9f8
mod2k

# ╔═╡ 709e2895-bac4-4040-b5a6-95d4c0afd518
md"""
- Edit all scales and shifts, with one row for each model component (from `mod.comps`) and one column for each optic (`_.scale, _.shift`).
Here, the second argument to `ItemsRowsInput` is the optic defining target items (table rows).
"""

# ╔═╡ 4a0b3eaf-a18a-4d7d-ba7e-57c41b79b1dd
@bind mod3 ItemsRowsInput(mod₀, (@o _.comps |> keyed(∗)), (
	(@o _.scale) => Slider(0:0.1:5, show_value=true),
	(@o _.shift) => Slider(0.0:10, show_value=true),
))

# ╔═╡ 694ee409-31be-4d70-b554-d7ca5ab30613
mod3

# ╔═╡ 63d5735b-8c27-4ee7-9ab3-d1108428b690
md"""
- Same, but now components got into table columns. We use vertical sliders here, but any widgets are allowed.
"""

# ╔═╡ bcf841b2-be82-444f-bfbb-d7754fec4a7d
@bind mod4 ItemsColumnsInput(mod₀, (@o _.comps |> keyed(∗)), (
	(@o _.scale) => Slider(0:0.1:5, style=(var"-webkit-appearance"="slider-vertical", width="1em"), show_value=true),
	(@o _.shift) => Slider(0.0:10, style=(var"-webkit-appearance"="slider-vertical", width="1em"), show_value=true),
))

# ╔═╡ fff95e73-229e-4405-9df9-466261af5540
mod4

# ╔═╡ 611b478d-1d14-44be-943f-44efea4a66f2
md"""
- Edit scales under log-transformation:
"""

# ╔═╡ 210e79ca-2cf7-47f1-89d4-3c1b535582a3
@bind mod5 ItemsRowsInput(mod₀, (@o _.comps |> keyed(∗)), (
	(@o _.scale |> log10) => Slider(-1:0.1:1, show_value=true),
	(@o _.shift) => Slider(0.0:10, show_value=true),
))

# ╔═╡ 421e2adc-6136-47dc-bd90-0954a58ad171
mod5

# ╔═╡ 597e921c-8eff-414d-9da8-af347dedc06b
md"""
Arbitrary functions are supported, see `Accessors`.
"""

# ╔═╡ 0170c657-2343-47c8-b976-adec872e0653
md"""
- Unit support. Let's create a struct instance with units:
"""

# ╔═╡ 2045f2e1-2c9e-4fd3-bb95-554bc87b5449
modu₀ = SumModel((
	ExpModel(2.0u"km", 5.),
	ExpModel(0.5u"km", 2.),
	ExpModel(0.5u"km", 8.),
))

# ╔═╡ 09011265-1d6c-444d-a4ec-07f16ce99774
md"""
... and edit them. Note that we use `ustrip` transformation to define units for sliders, and the `Unit` column is added automatically:
"""

# ╔═╡ d3daa105-a418-40f9-97f3-795c8a650d44
@bind mod6_ ColumnInput(modu₀, (
	(@o _.comps[∗].scale |> ustrip(u"m", _)) |> enumerated => Slider(0:10.:10^4, show_value=true),
	(@o _.comps[∗].shift) |> enumerated => Slider(0.0:10, show_value=true),
))

# ╔═╡ 98bfbfa7-2e4e-4dc0-a8b1-abfa1b17bdd5
@bind mod6 ColumnInput(modu₀, (
	(@o _.comps[∗].scale |> ustrip) |> enumerated => Slider(0:0.1:10, show_value=true),
	(@o _.comps[∗].shift) |> enumerated => Slider(0.0:10, show_value=true),
))

# ╔═╡ b763380f-7b34-45fa-bb3d-8e4b0759e24e
md"""
- Sometimes, it's possible to construct an object without a pre-existing instance. See the underlying `AccessorsExtra.construct` function.
Compare the two cases below. In the first, we pass an existing `SVector` to `ColumnInput`, and modify its norm and angle:
"""

# ╔═╡ 18ed596b-d25f-4b3e-968b-051c639de4ac
@bind v1 ColumnInput(SVector(3, 0), (
	norm => Slider(0:1.:10, show_value=true),
	@o(atan(_...) |> rad2deg) => Slider(-180:15.:180, show_value=true)
))

# ╔═╡ 8531795c-9de8-4961-a0b5-23ad5121264f
v1

# ╔═╡ a8df2a3c-96ca-4f92-8365-722880fab7f0
md"""
Alternatively, just pass a type (`SVector{2}`) and it will be automatically constructed from norm and angle:
"""

# ╔═╡ 9855c5a0-0084-444e-82b9-919716ec62d9
@bind v2 ColumnInput(SVector{2}, (
	norm => Slider(0:1:10, default=5, show_value=true),
	@o(atan(_...) |> rad2deg) => Slider(-180:15:180, default=0, show_value=true)
))

# ╔═╡ 2d8c725b-5200-4be2-8db9-20a595f3e476
v2

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AccessorsExtra = "33016aad-b69d-45be-9359-82a41f556fd4"
IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoTables = "e64c0356-fa58-4209-b01c-f6c8ed5474f5"
PlutoUIExtra = "a011ac08-54e6-4ec3-ad1c-4165f16ac4ce"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
AccessorsExtra = "~0.1.68"
IntervalSets = "~0.7.9"
PlutoTables = "~0.1.5"
PlutoUIExtra = "~0.1.6"
StaticArrays = "~1.9.2"
Unitful = "~1.19.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "a1c6133ca50c5d9d3029e0f9597b4344bc71f35a"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "MacroTools", "Test"]
git-tree-sha1 = "cb96992f1bec110ad211b7e410e57ddf7944c16f"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.35"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"

[[deps.AccessorsExtra]]
deps = ["Accessors", "CompositionsBase", "ConstructionBase", "DataPipes", "InverseFunctions", "Reexport"]
git-tree-sha1 = "5398fd9dcd875e4c2950fe67c292de2dea54f05f"
uuid = "33016aad-b69d-45be-9359-82a41f556fd4"
version = "0.1.68"

    [deps.AccessorsExtra.extensions]
    ColorTypesExt = "ColorTypes"
    DictArraysExt = "DictArrays"
    DictionariesExt = "Dictionaries"
    DistributionsExt = "Distributions"
    DomainSetsExt = "DomainSets"
    FlexiMapsExt = "FlexiMaps"
    FlexiMapsStructArraysExt = ["FlexiMaps", "StructArrays"]
    LinearAlgebraExt = "LinearAlgebra"
    SkipperExt = "Skipper"
    StaticArraysExt = "StaticArrays"
    StructArraysExt = "StructArrays"
    TestExt = "Test"
    URIsExt = "URIs"

    [deps.AccessorsExtra.weakdeps]
    ColorTypes = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
    DictArrays = "e9958f2c-b184-4647-9c5a-224a61f6a14b"
    Dictionaries = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    DomainSets = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
    FlexiMaps = "6394faf6-06db-4fa8-b750-35ccc60383f7"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    Skipper = "fc65d762-6112-4b1c-b428-ad0792653d81"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    URIs = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"

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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.DataPipes]]
git-tree-sha1 = "64ae76311a9e3a300ccabc1d8d5d4d36b9d047c7"
uuid = "02685ad9-2d12-40c3-9f73-c6aeda6a7ff5"
version = "0.3.14"

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
deps = ["Accessors", "DataPipes", "InverseFunctions"]
git-tree-sha1 = "d1d0d024041703987c369f7e314adf7ca1852652"
uuid = "6394faf6-06db-4fa8-b750-35ccc60383f7"
version = "0.1.24"

    [deps.FlexiMaps.extensions]
    DictionariesExt = "Dictionaries"
    IntervalSetsExt = "IntervalSets"
    StructArraysExt = "StructArrays"

    [deps.FlexiMaps.weakdeps]
    Dictionaries = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
git-tree-sha1 = "581191b15bcb56a2aa257e9c160085d0f128a380"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.9"
weakdeps = ["Random", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

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
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoTables]]
deps = ["AccessorsExtra", "CompositionsBase", "DataPipes", "FlexiMaps", "HypertextLiteral", "PlutoUI"]
path = "../../../../../../../Users/aplavin/.julia/dev/PlutoTables"
uuid = "e64c0356-fa58-4209-b01c-f6c8ed5474f5"
version = "0.1.5"
weakdeps = ["Unitful"]

    [deps.PlutoTables.extensions]
    UnitfulExt = "Unitful"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

[[deps.PlutoUIExtra]]
deps = ["AbstractPlutoDingetjes", "FlexiMaps", "HypertextLiteral", "InteractiveUtils", "IntervalSets", "Markdown", "PlutoUI", "Random", "Reexport"]
git-tree-sha1 = "ce98462ba6d77adf4b1b3eba4f391df8acb694fd"
uuid = "a011ac08-54e6-4ec3-ad1c-4165f16ac4ce"
version = "0.1.6"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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
version = "1.10.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "7b0e9c14c624e435076d19aea1e5cbdec2b9ca37"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.2"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

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
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─0e0ca714-0b17-4406-b43a-0a1e3e8eef96
# ╠═64229c85-c53d-4b77-bf06-c7cf7908d83c
# ╠═e82cad05-8438-41c6-9017-225dcd13b90e
# ╠═534f8121-dfc6-4df4-8bae-11c20f28424c
# ╠═f9b4544e-a767-4b84-9fdb-87cf0d4b1ed9
# ╠═0b8514f0-953c-49ea-8dae-67eabd30432c
# ╠═956329b7-b96d-4a3b-8324-aeb2f2c52195
# ╠═e1c7baa6-9477-4325-bcb3-a2d2126612d5
# ╠═87d6e145-c147-4c89-bb22-c6c0f6ae5597
# ╠═90bb0c1a-0c92-4d7b-90bf-d0fdce2d359f
# ╟─d037507e-dc38-426d-9973-e9919bdafa40
# ╠═1d6dc40b-9a40-432b-93c0-daa344d8de3e
# ╟─2044c277-0636-4bd4-a6d7-b349cb9012cd
# ╠═746f5643-0d92-4ccf-af66-175806c56c03
# ╟─7d318069-96bc-48ef-a98e-487e7ce02b17
# ╟─d6d49311-ef4f-4bde-8064-71e9dc20812f
# ╠═23aa9375-b404-428b-8158-8f1b779c5eef
# ╠═87182d19-9705-44ca-8c4f-591c1510b179
# ╟─b180cc61-de6e-4546-a97e-dbb5cfc1d4e4
# ╠═6b12af31-791a-4919-9de1-5a35202cb2f7
# ╠═ca01b0d5-0a06-4ac2-846d-c9478e964295
# ╟─b8dbe2b5-75ab-4744-918f-cb4c940e7638
# ╠═bfa7c1a2-9259-4aa4-b69c-c982674ccc0d
# ╠═314c256e-c695-4e8a-8641-402cb733f9f8
# ╟─709e2895-bac4-4040-b5a6-95d4c0afd518
# ╠═4a0b3eaf-a18a-4d7d-ba7e-57c41b79b1dd
# ╠═694ee409-31be-4d70-b554-d7ca5ab30613
# ╟─63d5735b-8c27-4ee7-9ab3-d1108428b690
# ╠═bcf841b2-be82-444f-bfbb-d7754fec4a7d
# ╠═fff95e73-229e-4405-9df9-466261af5540
# ╟─611b478d-1d14-44be-943f-44efea4a66f2
# ╠═210e79ca-2cf7-47f1-89d4-3c1b535582a3
# ╠═421e2adc-6136-47dc-bd90-0954a58ad171
# ╟─597e921c-8eff-414d-9da8-af347dedc06b
# ╟─0170c657-2343-47c8-b976-adec872e0653
# ╠═2045f2e1-2c9e-4fd3-bb95-554bc87b5449
# ╟─09011265-1d6c-444d-a4ec-07f16ce99774
# ╠═d3daa105-a418-40f9-97f3-795c8a650d44
# ╠═98bfbfa7-2e4e-4dc0-a8b1-abfa1b17bdd5
# ╟─b763380f-7b34-45fa-bb3d-8e4b0759e24e
# ╠═18ed596b-d25f-4b3e-968b-051c639de4ac
# ╠═8531795c-9de8-4961-a0b5-23ad5121264f
# ╟─a8df2a3c-96ca-4f92-8365-722880fab7f0
# ╠═9855c5a0-0084-444e-82b9-919716ec62d9
# ╠═2d8c725b-5200-4be2-8db9-20a595f3e476
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
