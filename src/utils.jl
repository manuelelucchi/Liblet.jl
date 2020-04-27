import Base

const Iterable = Union{Set, AbstractSet, AbstractArray}

const NullableAbstractString = Union{AbstractString, Nothing}

Base.map(f, s::Set) = Set(Base.map(f, collect(s)))

Base.show(io::IO, arr::AbstractArray) = begin
    res = "["
    for i in arr[begin:end-1]
        res = res * string(i) * ", "
    end
    res = res * string(arr[end]) * "]"
    Base.show(io, res)
end

Base.:|(a::AbstractArray, b::AbstractArray) = union(a, b)

Base.:∪(a, b) = union(a, b)

Base.:∩(a, b) = intersect(a, b)

Base.:-(a::AbstractSet, b::AbstractSet) = setdiff(a, b)

Base.:-(a::AbstractSet, b) = setdiff(a, Set([b]))

Base.:⊂(a, b) = issubset(a, b)