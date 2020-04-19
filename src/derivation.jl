include("grammar.jl")

struct Derivation
    G::Grammar
    steps::Array{Tuple{Int, Int}}
    sf::Array
    repr::AbstractString
    Derivation(G::Grammar) = new(G, [], [G.S], G.S)
    Derivation(G::Grammar, steps::Array{Tuple{Int, Int}}, sf::Array, repr::AbstractString) = new(G, steps, sf, repr)
end

function step(d::Derivation, prod::Int, pos::Int)::Derivation
    sf = d.sf
    P = astype0(d.G.P[prod])
    #if sf = check da fare
    sf = [c for c in [sf[begin:pos]; P.right; sf[pos + length(P.left):end]] if c != ϵ]
    steps = [d.steps; [(prod, pos)]]
    repr = d.repr * " -> " * string(sf)
    clone = Derivation(d.G, steps, sf, repr)
    return clone
end

function step(d::Derivation, prod::AbstractArray{Tuple{Int, Int}})::Derivation
    res = d
    for (nprod, pos) in prod
        res = step(res, nprod, nothing)
    end
    return res
end

function leftmost(d::Derivation, prod::Int)::Derivation
    if !d.G.iscontextfree
        throw(ArgumentError("Cannot perform a leftmost derivation on a non context-free grammar"))
    end
    if length(d.sf) == 0
        throw(ArgumentError("Cannot apply: there are non terminals"))
    end
    for (pos, symbol) in enumerate(d.sf)
        if symbol in d.G.N
            if d.G.P[prod].left == symbol
                return step(d, prod, pos)
            else 
                throw(ArgumentError(" Cannot apply: the leftmost nonterminal of"))
            end
        end
    end
end

function leftmost(d::Derivation, prod::AbstractArray{Int})::Derivation
    res = d
    for i in prod 
        res = leftmost(d, i)
    end
    return res
end

function rightmost(d::Derivation, prod::Int)::Derivation
    if !d.G.iscontextfree
        throw(ArgumentError("Cannot perform a leftmost derivation on a non context-free grammar"))
    end
    if length(d.sf) == 0
        throw(ArgumentError("Cannot apply: there are non terminals"))
    end
    for (pos, symbol) in enumerate(reverse(d.sf))
        if symbol in d.G.N
            if d.G.P[prod].left == symbol
                return step(d, prod, pos)
            else 
                throw(ArgumentError(" Cannot apply: the leftmost nonterminal of"))
            end
        end
    end
end

function rightmost(d::Derivation, prod::AbstractArray{Int})::Derivation
    res = d
    for i in prod 
        res = rightmost(d, i)
    end
    return res
end

function possiblesteps(d::Derivation; prod::Union{Int, Nothing} = nothing, pos::Union{Int, Nothing} = nothing)
    res = []
    type0prods = map(x -> astype0(x), d.G.P)
    for (n, P) in (prod === nothing ? enumerate(type0prods) : [(prod, type0prods[prod])])
        for p in (pos === nothing ? range(1, length=(length(d.sf) - length(P.left) + 1)) : [pos])
            if [d.sf[p:p + length(P.left) - 1]] == P.left || P.left in [d.sf[p:p + length(P.left) - 1]]
                push!(res, (n, p))
            end
        end
    end
    return res
end