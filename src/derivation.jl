import Base

include("grammar.jl")

HAIR_SPACE = '\u200a'

"""
A *derivation*.
"""
struct Derivation
    "The grammar to which the derivations refers to."
    G::Grammar
    "The derivation steps"
    steps::Array
    "The sentential form of the derivations"
    sf::Array
    "The string representation of the derivation"
    repr::AbstractString
end

### Constuctors ###

"""
    Derivation(G::Grammar)::Derivation 
Builds a [`Derivation`](@ref) from a given [`Grammar`](@ref).
"""
Derivation(G::Grammar)::Derivation = Derivation(G, [], [G.S], G.S)

### Operators ###

"""
    next(d::Derivation, prod::Int, pos::Int)::Derivation
Applies the specified production to the given position in the sentential form.
"""
function next(d::Derivation, prod::Int, pos::Int)::Derivation
    sf = d.sf
    prod = ensure_production_index(d, prod)
    P = astype0(d.G.P[prod])
    if sf[pos:pos+length(P.left)-1] != P.left throw(ArgumentError("Cannot apply " * string(P) * " at position " * string(pos) * " of " * string(sf))) end
    sf = [c for c ∈ [sf[begin:pos-1]; P.right; sf[pos + length(P.left):end]] if c ≠ "ε"]
    steps = [d.steps; [(prod, pos)]]
    repr = string(d.repr," -> ", join(sf,HAIR_SPACE))
    clone = Derivation(d.G, steps, sf, repr)
    return clone
end

"""
    next(d::Derivation, prod::Production, pos::Int)::Derivation
Applies the specified [`Production`](@ref) to the given position in the sentential form.
"""
function next(d::Derivation, prod::Production, pos::Int)::Derivation
    p = ensure_production_index(d, prod)
    return next(d, p, pos)
end

"""
    next(d::Derivation, prod::Int, pos::Int)::Derivation
Applies the specified productions to the given position in the sentential form, one by one
"""
function next(d::Derivation, prod::AbstractArray{Tuple{Int, Int}})::Derivation
    res = d
    for (nprod, pos) ∈ prod
        res = next(res, nprod, pos)
    end
    return res
end

"""
    leftmost(d::Derivation, prod::Int)::Derivation
Performs a *leftmost* derivation step.
Applies the specified production to the current leftmost nonterminal in the sentential form.
"""
function leftmost(d::Derivation, prod::Int)::Derivation
    if ~d.G.iscontextfree
        throw(ArgumentError("Cannot perform a leftmost derivation on a non context-free grammar"))
    end
    if length(d.sf) == 0
        throw(ArgumentError("Cannot apply " * string(d.G.P[prod]) * ": there are non terminals in " * string(d.sf)))
    end
    for (pos, symbol) ∈ enumerate(d.sf)
        if symbol ∈ d.G.N
            if d.G.P[prod].left == symbol
                return next(d, prod, pos)
            else 
                throw(ArgumentError("Cannot apply " * string(d.G.P[prod]) * ": the leftmost nonterminal of " * string(d.sf) * " is " * string(symbol)))
            end
        end
    end
    throw(ArgumentError("The specified production could not be found"))
end

"""
    leftmost(d::Derivation, prod::Production)::Derivation
Performs a *leftmost* derivation step.
Applies the specified [`Production`](@ref) to the current leftmost nonterminal in the sentential form.
"""
function leftmost(d::Derivation, prod::Production)::Derivation
    p = ensure_production_index(d,prod)
    return leftmost(d, p)
end

"""
    leftmost(d::Derivation, prod::AbstractArray{Production})::Derivation
Performs a *leftmost* derivation step.
Applies the specified productions to the current leftmost nonterminal in the sentential form, one by one.
"""
function leftmost(d::Derivation, prod::AbstractArray{Production})::Derivation
    res = d
    for i ∈ prod 
        res = leftmost(res, i)
    end
    return res
end

"""
    leftmost(d::Derivation, prod::AbstractArray{Int})::Derivation
Performs a *leftmost* derivation step.
Applies the specified productions to the current leftmost nonterminal in the sentential form, one by one.
"""
function leftmost(d::Derivation, prod::AbstractArray{Int})::Derivation
    res = d
    for i ∈ prod 
        res = leftmost(res, i)
    end
    return res
end

"""
    rightmost(d::Derivation, prod::Int)::Derivation
Performs a *rightmost* derivation step.
Applies the specified production(s) to the current rightmost nonterminal in the sentential form.
"""
function rightmost(d::Derivation, prod::Int)::Derivation
    if ~d.G.iscontextfree
        throw(ArgumentError("Cannot perform a rightmost derivation on a non context-free grammar"))
    end
    if length(d.sf) == 0
        throw(ArgumentError("Cannot apply " * string(d.G.P[prod]) * ": there are non terminals in " * string(d.sf)))
    end
    for (pos, symbol) ∈ (enumerate(d.sf) |> collect |> reverse)
        if symbol ∈ d.G.N
            if d.G.P[prod].left == symbol
                return next(d, prod, pos)
            else 
                throw(ArgumentError("Cannot apply " * string(d.G.P[prod]) * ": the rightmost nonterminal of " * string(d.sf) * " is " * string(symbol)))
            end
        end
    end
    throw(ArgumentError("The specified production could not be found"))
end

"""
    rightmost(d::Derivation, prod::Production)::Derivation
Performs a *rightmost* derivation step.
Applies the specified [`Production`](@ref) to the current rightmost nonterminal in the sentential form.
"""
function rightmost(d::Derivation, prod::Production)::Derivation
    p = ensure_production_index(d,prod)
    return rightmost(d, p)
end

"""
    rightmost(d::Derivation, prod::Int)::Derivation
Performs a *rightmost* derivation step.
Applies the specified productions to the current rightmost nonterminal in the sentential form, one by one.
"""
function rightmost(d::Derivation, prod::AbstractArray{Int})::Derivation
    res = d
    for i ∈ prod 
        res = rightmost(res, i)
    end
    return res
end

"""
    rightmost(d::Derivation, prod::AbstractArray{Production})::Derivation
Performs a *rightmost* derivation step.
Applies the specified productions to the current rightmost nonterminal in the sentential form, one by one.
"""
function rightmost(d::Derivation, prod::AbstractArray{Production})::Derivation
    res = d
    for i ∈ prod 
        res = rightmost(res, i)
    end
    return res
end

"""
    possiblesteps(d::Derivation; prod::Union{Int, Nothing} = nothing, pos::Union{Int, Nothing} = nothing)
Returns all the possible steps that can be performed given the grammar and current *sentential form*.

Determines all the position of the *sentential form* that correspond to the left-hand side of
one of the production in the grammar, returning the position and production number. If a
production is specified, it yields only the pairs referring to it; similarly, if a position
is specified, it yields only the pairs referring to it.
"""
function possiblesteps(d::Derivation; prod::Union{Int, Nothing} = nothing, pos::Union{Int, Nothing} = nothing)
    res = []
    type0prods = map(x -> astype0(x), d.G.P)
    for (n, P) ∈ (prod === nothing ? enumerate(type0prods) : [(prod, type0prods[prod])])
        for p ∈ (pos === nothing ? range(1, length=(length(d.sf) - length(P.left) + 1)) : [pos])
            if [d.sf[p:p + length(P.left) - 1]] == P.left || P.left ∈ [d.sf[p:p + length(P.left) - 1]]
                push!(res, (n, p))
            end
        end
    end
    return res
end

"""
    sententialform(d::Derivation)
Returns the sentential form of the [`Derivation`](@ref).
"""
sententialform(d::Derivation) = d.sf

"""
    steps(d::Derivation)
Returns the steps performed by the [`Derivation`](@ref)
"""
steps(d::Derivation) = d.steps

ensure_production_index(d::Derivation, prod::Int)::Int = if 1 <= prod <= length(d.G.P) return prod else throw(ArgumentError("There is no production of index " * string(prod) * " in G")) end

ensure_production_index(d::Derivation, prod::Production)::Int = if prod ∈ d.G.P return findfirst(x -> x == prod, d.G.P)[1] else throw(ArgumentError("Production " * string(prod) * " does not belong to G")) end

### Operators ###

Base.show(io::IO, d::Derivation) = Base.show(io, d.repr)

Base.:(==)(x::Derivation, y::Derivation) = (x.G, x.steps) == (y.G, y.steps)

Base.hash(x::Derivation) = Base.hash((x.G, x.steps))