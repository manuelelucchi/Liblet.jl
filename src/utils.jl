import Base

const Iterable = Union{Set,AbstractSet,AbstractArray}

const NullableAbstractString = Union{AbstractString,Nothing}

const CykTable = Dict{Tuple{AbstractString,AbstractString},AbstractString}

Base.map(f, s::Set) = Set(Base.map(f, collect(s)))

Base.:-(a::AbstractSet, b::AbstractSet) = setdiff(a, b)

Base.:-(a::AbstractSet, b) = setdiff(a, Set([b]))