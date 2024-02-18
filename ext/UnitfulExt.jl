module UnitfulExt

using Unitful
import PlutoTables: _split_unit

_split_unit(o::Base.Fix1{typeof(ustrip)}, _...) = (identity, string(o.x))
_split_unit(o::typeof(ustrip), obj) = _split_unit(Base.Fix1(ustrip, unit(obj)), obj)

end
