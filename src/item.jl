include("production.jl")

"""A dotted production, also known as an *Item*."""
struct Item <: AbstractProduction
    left::Union{AbstractString, AbstractArray}
    right::Union{AbstractString, AbstractArray}
    pos::Int
    function Item(left, right, pos::Int = 0)
        p = Production(left, right)
        return Item(p, pos)
    end
    Item(prod::Production, pos::Int = 0) = new(prod.left, prod.right, pos)
end

### Functions ###

"""
    parseitem(input::AbstractString, iscontextfree::Bool = true)::Array{Item}
Returns an Array of Items obtained from the given string.
"""
parseitem(input::AbstractString, iscontextfree::Bool = true)::Array{Item} = parseproduction(input, iscontextfree) |> (x->map(y-> Item(y), x))

"""
    astype0(p::Production)::Production
Returns a new `Production` that is type 0
"""
astype0(i::Item)::Item = isa(i.left, AbstractArray) ? i : Item([i.left], i.right, i.pos)

"""
    afterdotsymbol(item::Item)::Union{AbstractString,Nothing}
Returns the symbol after the dot.
"""
afterdotsymbol(item::Item)::Union{AbstractString,Nothing} = item.pos < length(item.right) ? item.right[item.pos] : nothing

"""
    advance(item::Item, x::AbstractString)::Item
Returns a new `Item` obtained advancing the dot past the given symbol.
"""
advance(item::Item, x::AbstractString)::Union{Item,Nothing} = item.pos < length(item.right) ? Item(item.left, item.right, item.pos+1) : nothing

### Operators ###

Base.:(==)(x::Item, y::Item) = (x.left, x.right, x.pos) == (y.left, y.right, y.pos)

Base.:<(x::Item, y::Item) = (x.left, x.right, x.pos) == (y.left, y.right, y.pos)

Base.hash(x::Item) = Base.hash((x.left, x.right, x.pos))

Base.show(io::IO, x::Item) = Base.show(io, (x.left, x.right, x.pos))

Base.iterate(x::Item, i...) = Base.iterate((x.left, x.right, x.pos), i...)

Base.isless(x::Item, y::Item) = Base.isless((x.left, x.right, x.pos), (y.left, y.right, y.pos))