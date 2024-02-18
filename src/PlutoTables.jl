module PlutoTables

using DataPipes
using FlexiMaps: flatmap
using AccessorsExtra
using CompositionsBase
using HypertextLiteral
using PlutoUI

export ColumnInput, RowInput, ItemsColumnsInput, ItemsRowsInput


function ColumnInput(ctype::Type, optics)
    os_full = _fullspec(optics)
    optshead = [
        map(or -> or.label, os_full),
        map(or -> _unit_to_html(or.unit), os_full),
    ]
    if all(or -> isnothing(or.unit), os_full)
        deleteat!(optshead, 2)
    end
    @p PlutoUI.combine() do Child
        tbldata = [
            map(os_full) do or
                Child(or.widget)
            end
        ] |> stack
        _table_html([], optshead, eachrow(tbldata))
    end |>
    PlutoUI.Experimental.transformed_value() do tup
        construct(ctype, (first.(optics) .=> tup)...)
    end
end

RowInput(obj, optics) = ItemsRowsInput(obj, identity, optics)
ColumnInput(obj, optics) = ItemsColumnsInput(obj, identity, optics)

ItemsColumnsInput(obj, optics) = ItemsColumnsInput(obj, keyed(∗), optics)
function ItemsColumnsInput(obj, itemsoptic, optics)
    items = getall(obj, itemsoptic)
    os_full = _fullspec(optics, stripcontext(first(items)))
    itemshead = hascontext(itemsoptic) ? [[""; ""; map(items) do kit
        first(kit)
    end |> collect]] : []
    optshead = [
        flatmap(or -> Any[RowSpan(or.label, or.nrow); fill(nothing, or.nrow-1)], os_full),
        flatmap(or -> Any[RowSpan(_unit_to_html(or.unit), or.nrow); fill(nothing, or.nrow-1)], os_full),
    ]
    if all(or -> isnothing(or.unit), os_full)
        isempty(itemshead) || deleteat!(only(itemshead), 2)
        deleteat!(optshead, 2)
    end
    if all(or -> or.optic == identity, os_full)
        isempty(itemshead) || deleteat!(only(itemshead), 1)
        deleteat!(optshead, 1)
    end
    @p PlutoUI.combine() do Child
        tbldata = map(items .|> stripcontext) do item
            flatmap(os_full) do or
                map(getall(item, or.optic)) do b
                    cw = Child(@set $(or.widget).default = stripcontext(b))
                    hascontext(b) ? @htl("$(b.ctx) $cw") : cw
                end
            end
        end |> stack
        _table_html(itemshead, optshead, eachrow(tbldata))
    end |>
    PlutoUI.Experimental.transformed_value() do tup
        tup = vec(permutedims(reshape(collect(tup), (length(items), :)))) |> Tuple
        setall(obj, stripcontext.(AccessorsExtra.concat(first.(optics)...) ∘ itemsoptic), tup)
    end
end


ItemsRowsInput(obj, optics) = ItemsRowsInput(obj, keyed(∗), optics)
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
                map(getall(item, or.optic)) do b
                    cw = Child(@set $(or.widget).default = stripcontext(b))
                    hascontext(b) ? @htl("$(b.ctx) $cw") : cw
                end
            end
        end |> stack
        _table_html(optshead, itemshead, eachcol(tbldata))
    end |>
    PlutoUI.Experimental.transformed_value() do tup
        setall(obj, stripcontext.(AccessorsExtra.concat(first.(optics)...) ∘ itemsoptic), tup)
    end
end


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

struct RowSpan{T}
    value::T
    rowspan::Int
end

struct ColSpan{T}
    value::T
    colspan::Int
end

_to_td(::Nothing) = nothing
_to_td(x) = @htl("<td>$x</td>")
_to_td(x::RowSpan{Nothing}) = nothing
_to_td(x::RowSpan) = @htl("<td rowspan=$(x.rowspan)>$(x.value)</td>")
_to_td(x::ColSpan{Nothing}) = nothing
_to_td(x::ColSpan) = @htl("<td colspan=$(x.colspan)>$(x.value)</td>")


_fullspec(optics, obj) = map(optics) do (optic, spec)
    oshow, unit = _split_unit(optic, obj)
    (; optic, unit, label=sprint(print, stripcontext(oshow); context=:compact => true), nrow=length(getall(obj, optic)), _from_wspec(spec)...)
end
_fullspec(optics) = map(optics) do (optic, spec)
    oshow, unit = _split_unit(optic)
    (; optic, unit, label=sprint(print, stripcontext(oshow); context=:compact => true), _from_wspec(spec)...)
end


_split_unit(::typeof(rad2deg), _...) = (identity, "°")
_split_unit(o, _...) = (o, nothing)
function _split_unit(o::AccessorsExtra.ContextOptic, obj...)
    oc = stripcontext(o)
    oshowc, unit = _split_unit(oc, obj...)
    (set(o, stripcontext, oshowc), unit)
end
function _split_unit(o::ComposedFunction)
    oshow, unit = _split_unit(o.outer)
    (_stripidentity(oshow ∘ o.inner), unit)
end
function _split_unit(o::ComposedFunction, obj)
    oshow, unit = _split_unit(o.outer, first(getall(obj, o.inner)))
    (_stripidentity(oshow ∘ o.inner), unit)
end

_stripidentity(o::ComposedFunction) = @delete decompose(o) |> filter(==(identity))
_stripidentity(o) = o


_unit_to_html(::Nothing) = ""
_unit_to_html(ustr::String) = "($ustr)"


_from_wspec(spec::NamedTuple) = spec
_from_wspec(widget) = (; widget)

end
