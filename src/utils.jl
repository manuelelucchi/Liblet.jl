import Base

const hairspace = "\u200a"

const Iterable = Union{Set,AbstractSet,AbstractArray}

const NullableAbstractString = Union{AbstractString,Nothing}

const CykTable = Dict{Tuple{Int,Int},Array{String,1}}

function stringify(input, left, right, keep_brackets)
    i = collect(input)
    if length(i) == 1 && isa(input, Iterable)
        if keep_brackets
            return "$left$(i[1])$right"
        else 
            return "$(i[1])"
        end
    elseif length(i) == 1
        return "$input"
    else
        return "$left$(join(i, ", "))$right"
    end
end

stringifyarray(input; keep_brackets=false) = stringify(input, "[", "]", keep_brackets)

stringifyset(input; keep_brackets=true) = stringify(input, "{", "}", keep_brackets)

stringifytuple(input; keep_brackets=false) = stringify(input, "(", ")", keep_brackets)

Base.map(f, s::Set) = Set(Base.map(f, collect(s)))

Base.:-(a::AbstractSet, b::AbstractSet) = setdiff(a, b)

Base.:-(a::AbstractSet, b) = setdiff(a, Set([b]))

libletstring(s::Iterable) = collect(s) |> x -> join(x, hairspace)