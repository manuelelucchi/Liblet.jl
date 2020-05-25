import Base

const hairspace = "\u200a"

const Iterable = Union{Set,AbstractSet,AbstractArray}

const NullableAbstractString = Union{AbstractString,Nothing}

const CykTable = Dict{Tuple{Int,Int},Array{String,1}}

stringifyarray(input) = if (collect(input) |> length) > 1 "[$(join(input, ", "))]" else "$(input)" end

stringifyset(input; show_brackets_anyway=true) = if (collect(input) |> length) > 1 || show_brackets_anyway "{$(join(input, ", "))}" else "$(input)" end

Base.map(f, s::Set) = Set(Base.map(f, collect(s)))

Base.:-(a::AbstractSet, b::AbstractSet) = setdiff(a, b)

Base.:-(a::AbstractSet, b) = setdiff(a, Set([b]))

libletstring(s::Iterable) = collect(s) |> x->join(x, hairspace)