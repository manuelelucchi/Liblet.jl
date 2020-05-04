import Base

include("utils.jl")

"Base type for productions"
abstract type AbstractProduction end

"""
    Production
A grammar production.
"""
struct Production <: AbstractProduction
    "The left-hand side of the production"
    left::Union{AbstractString, AbstractArray}
    "The right-hand side of the production"
    right::Union{AbstractString, AbstractArray}
    function Production(left, right)
        l = nothing
        r = nothing
        if typeof(left) <: AbstractString && left ≠ nothing && ~isempty(left)
            l = left
        elseif (typeof(left) <: AbstractArray || typeof(left) <: AbstractSet || typeof(left) <: Tuple) && ~isempty(left) && all(x-> typeof(x) <: AbstractString && x ≠ nothing && ~isempty(x), left)
            l = collect(left) 
        else
            throw(ArgumentError("Error in lhs"))
        end
    
        if typeof(right) <: AbstractString && right ≠ nothing && ~isempty(left)
            r = right
        elseif (typeof(right) <: AbstractArray || typeof(right) <: AbstractSet || typeof(right) <: Tuple) && ~isempty(right) && all(x-> typeof(x) <: AbstractString && x ≠ nothing && ~isempty(x), right)
            r = collect(right)
        else
            throw(ArgumentError("Error in rhs"))
        end
    
        if "ε" ∈ r && length(r) ≠ 1
            throw(ArgumentError("The right-hand side contains ε but has more than one symbol"))
        end
        new(l, r)
    end
end

### Functions ###

"""
    parseproduction(input::AbstractString, iscontextfree::Bool = true)::Array{Production}
Returns an Array of [`Production`](@ref) obtained from the given string.
"""
function parseproduction(input::AbstractString, iscontextfree::Bool = true)::Array{Production}
    P = []
    for p ∈ filter(f::AbstractString -> f ≠ "",split(input, "\n"))
        l, r = split(p, "->")
        left = split(l)
        if iscontextfree
            if length(left) ≠ 1
                throw(ArgumentError("Production marked as context free while it's not")) # To improve
            end
            left = left[1]
        end
        for right ∈ split(r, "|")
            push!(P, Production(left, split(right)))
        end
    end
    return P
end

"""
    suchthat(;left::AbstractString = nothing, right::AbstractString = nothing, rightlen::Int = nothing, right_is_suffix_of::AbstractString = nothing)::Array
A predicate (that is a one-argument function that retuns `true` or `false`) that is `true` weather the production
given as argument satisfies all the predicates given by the named arguments.
"""
function suchthat(;left::Union{AbstractString,Nothing} = nothing, right::Union{AbstractString,Nothing} = nothing, rightlen::Union{Int,Nothing} = nothing, right_is_suffix_of::Union{Iterable,Nothing} = nothing)
    c = []
    if left ≠ nothing
        push!(c, p::AbstractProduction -> p.left == left)
    end
    if right ≠ nothing 
        push!(c, p::AbstractProduction -> p.right == [right])
    end
    if rightlen ≠ nothing
        push!(c, p::AbstractProduction -> length(p.right) == rightlen)
    end
    if right_is_suffix_of ≠ nothing 
        d = collect(right_is_suffix_of)
        push!(c, p::AbstractProduction -> d[(end - (length(p.right) -1)):end] == collect(p.right))
    end
    return p::AbstractProduction -> all(cond(p) for cond ∈ c)
end

"""
    astype0(p::Production)::Production
Returns a new [`Production`](@ref) that is type 0
"""
astype0(p::Production)::Production = typeof(p.left) <: AbstractArray ? p : Production([p.left], p.right)

### Operators ###

Base.:(==)(x::Production, y::Production) = (x.left, x.right) == (y.left, y.right)

Base.:<(x::Production, y::Production) = (x.left, x.right) < (y.left, y.right)

Base.hash(x::Production) = Base.hash((x.left, x.right))

Base.show(io::IO, x::Production) = Base.show(io, (x.left, x.right))

Base.iterate(x::Production, i...) = Base.iterate((x.left, x.right), i...)

Base.isless(x::Production, y::Production) = Base.isless((x.left, x.right), (y.left, y.right))