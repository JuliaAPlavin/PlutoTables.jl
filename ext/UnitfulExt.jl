module UnitfulExt

using Unitful
import PlutoTables: _split_unit

_split_unit(o::Base.Fix1{typeof(ustrip)}) = (identity, string(o.x))

end
