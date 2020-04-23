import Base

include("utils.jl")
include("constants.jl")

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
end

### Constructors ###

function Production(left, right)
    l = nothing
    r = nothing
    if typeof(left) <: AbstractString && left != nothing 
        l = left
    elseif (typeof(left) <: AbstractArray || typeof(left) <: AbstractSet || typeof(left) <: Tuple) && all(map(x-> typeof(x) <: AbstractString && x != nothing, left))
        l = collect(left) 
    else
        throw(ArgumentError("Errore"))
    end

    if typeof(right) <: AbstractString && right != nothing 
        r = right
    elseif (typeof(right) <: AbstractArray || typeof(right) <: AbstractSet || typeof(right) <: Tuple) && all(map(x-> typeof(x) <: AbstractString && x != nothing, right))
        r = collect(right)
    else
        throw(ArgumentError("Errore"))
    end

    if ϵ in r && length(r) != 1
        throw(ArgumentError("The right-hand side contains ε but has more than one symbol"))
    end
    Production(l, r)
end

### Functions ###

"""
    parseproduction(input::AbstractString, iscontextfree::Bool = true)::Array{Production}
Returns an Array of Productions obtained from the given string.
"""
function parseproduction(input::AbstractString, iscontextfree::Bool = true)::Array{Production}
    P = []
    for p in split(input, "\n")
        l, r = split(p, "->")
        left = split(l)
        if iscontextfree
            if length(left) != 1
                throw(ArgumentError("Errore")) # To improve
            end
            left = left[1]
        end
        for right in split(r, "|")
            push!(P, Production(left, split(right)))
        end
    end
    return P
end

"""
    suchthat(p::AbstractProduction; left::AbstractString = nothing, right::AbstractString = nothing, rightlen::Int = nothing, right_is_suffix_of::AbstractString = nothing)::Array
A predicate (that is a one-argument function that retuns `true` or `false`) that is `true` weather the production
given as argument satisfies all the predicates given by the named arguments.
"""
function suchthat(p::AbstractProduction; left::AbstractString = nothing, right::AbstractString = nothing, rightlen::Int = nothing, right_is_suffix_of::AbstractString = nothing)
    c = []
    if left != nothing
        push!(c, p::AbstractProduction -> p.left == left)
    end
    if right != nothing 
        push!(c, p::AbstractProduction -> p.right == right)
    end
    if rightlen != nothing
        push!(c, p::AbstractProduction -> length(p.right) == rightlen)
    end
    if right_is_suffix_of != nothing 
        #push!(c, p::AbstractProduction -> ) todo
    end
    return p::AbstractProduction -> all(cond(p) for cond in c)
end

"""
    astype0(p::Production)::Production
Returns a new `Production` that is type 0
"""
astype0(p::Production)::Production = ifelse(typeof(p.left) <: AbstractArray, p, Production([p.left], p.right))

### Operators ###

Base.:(==)(x::Production, y::Production) = (x.left, x.right) == (y.left, y.right)

Base.:<(x::Production, y::Production) = (x.left, x.right) < (y.left, y.right)

Base.hash(x::Production) = Base.hash((x.left, x.right))

Base.show(io::IO, x::Production) = Base.show(io, (x.left, x.right))

Base.iterate(x::Production, i...) = Base.iterate((x.left, x.right), i...)