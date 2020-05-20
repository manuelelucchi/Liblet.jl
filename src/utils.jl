import Base

const Iterable = Union{Set,AbstractSet,AbstractArray}

const NullableAbstractString = Union{AbstractString,Nothing}

Base.map(f, s::Set) = Set(Base.map(f, collect(s)))

Base.:-(a::AbstractSet, b::AbstractSet) = setdiff(a, b)

Base.:-(a::AbstractSet, b) = setdiff(a, Set([b]))