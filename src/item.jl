include("production.jl")

"""A dotted production, also known as an *Item*."""
struct Item <: AbstractProduction
    left::Union{AbstractString,AbstractArray}
    right::Union{AbstractString,AbstractArray}
    pos::Int
    function Item(left, right, pos::Int = 1)
        if pos < 1 || pos > length(right) + 1 throw(ArgumentError("The dot position is invalid.")) end
        p = Production(left, right)
        return Item(p, pos)
    end
    Item(prod::Production, pos::Int = 1) = new(prod.left, prod.right, pos)
end

### Functions ###

"""
    parseitem(input::AbstractString, iscontextfree::Bool = true)::Array{Item}
Returns an Array of [`Item`](@ref) obtained from the given string.
"""
parseitem(input::AbstractString, iscontextfree::Bool = true)::Array{Item} = parseproduction(input, iscontextfree) |> (x->map(y->Item(y), x))

"""
    astype0(p::Item)::Item
Returns a new [`Item`](@ref) that is type 0
"""
astype0(i::Item)::Item = isa(i.left, AbstractArray) ? i : Item([i.left], i.right, i.pos)

"""
    afterdotsymbol(item::Item)::Union{AbstractString,Nothing}
Returns the symbol after the dot.
"""
afterdotsymbol(item::Item)::Union{AbstractString,Nothing} = item.pos <= length(item.right) ? item.right[item.pos] : nothing

"""
    advance(item::Item, x::AbstractString)::Item
Returns a new [`Item`](@ref) obtained advancing the dot past the given symbol.
"""
advance(item::Item, x::AbstractString)::Union{Item,Nothing} = if item.pos <= length(item.right) && item.right[item.pos] == x return Item(item.left, item.right, item.pos + 1) else nothing end

### Operators ###

Base.:(==)(x::Item, y::Item) = (x.left, x.right, x.pos) == (y.left, y.right, y.pos)

Base.:<(x::Item, y::Item) = (x.left, x.right, x.pos) == (y.left, y.right, y.pos)

Base.:>(x::Item, y::Item) = !(x == y || x < y)

Base.hash(x::Item) = Base.hash((x.left, x.right, x.pos))

Base.show(io::IO, x::Item) = Base.print(io, x)

Base.print(io::IO, x::Item) = Base.print(io, "$(stringifytuple(x.left))->$(stringifytuple(x.right[begin:x.pos - 1]))•$(stringifytuple(x.right[x.pos:end]))")

Base.iterate(x::Item, i...) = Base.iterate((x.left, x.right, x.pos), i...)

Base.isless(x::Item, y::Item) = Base.isless((x.left, x.right, x.pos), (y.left, y.right, y.pos))