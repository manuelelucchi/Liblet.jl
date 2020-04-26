import Base

include("production.jl")

"A grammar."
struct Grammar
    "The nonterminal symbols Set"
    N::Set
    "The terminal symbols Set"
    T::Set
    "The productions Array"
    P::Array
    "The starting symbol"
    S::AbstractString
    iscontextfree::Bool
end

### Constructors ###

function Grammar(N, T, P, S) 
    cf = all(map(x -> length(x.left) == 1, P))
    if intersect(N, T) != Set()
        throw(ArgumentError("The set of terminals and nonterminals are not disjoint"))
    end
    if !in(S, N)
        throw(ArgumentError("The start symbol is not a nonterminal."))
    end
    if cf
        badprods = [p for p in P if !in(p.left, N)]
        if !isempty(badprods)
            throw(ArgumentError("Error: Bad Productions"))
        end
    end
    badprods = [p for p in P if !(Set(astype0(p).left) ⊂ (N ∪ T ∪ Set([ϵ])))] 
    if !isempty(badprods)
        throw(ArgumentError("Error: Bad Productions"))
    end
    Grammar(N, T, P, S, cf)
end

"""
    Grammar(prods::AbstractString, iscontextfree = true)::Grammar
Builds a grammar obtained from the given string of productions.
"""
function Grammar(prods::AbstractString, iscontextfree = true)::Grammar
    P = parseproduction(prods, iscontextfree)
    S = nothing
    N = nothing
    T = nothing
    if iscontextfree
        S = P[1].left
        N = Set(map(x -> x.left, P))
        T = Set(vcat(map(x -> x.right, P)...)) - N - ϵ
    else
        S = P[1].left[1]
        symbols = union(Set(vcat(map(x -> x.left, P))), Set(vcat(map(x -> x.right, P))))
        N = Set(filter(x -> isuppercase(x[1]), symbols))
        T = symbols - N - ϵ
    end
    G = Grammar(N, T, P, S)
    if iscontextfree
        if !G.iscontextfree 
            throw(ArgumentError("The resulting grammar is not context-free, even if so requested."))
        end
    end
    return G
end

### Functions ###

"""
    alternatives(g::Grammar, N::Array)::Array
Returns all the right-hand sides alternatives matching the given nonterminal.
"""
alternatives(g::Grammar, N::Array)::Array = [P.right for P in g.P if P.left == N]

"""
    restrict(g::Grammar, symbols::Set)
Returns a grammar using only the given symbols.
"""
restrict(g::Grammar, symbols::Set) = Grammar(g.N ∩ symbols, g.T ∩ symbols, [P for P in g.P if (Set([P.left]) ∪ Set(P.right)) <= symbols], g.S)

### Operators ###

Base.:(==)(x::Grammar, y::Grammar) = (x.N, x.T, sort(x.P), x.S) == (y.N, y.T, sort(x.S), y.S)

Base.hash(g::Grammar) = Base.hash((g.N, g.T, sort(g.P), g.S))

Base.show(io::IO, g::Grammar) = Base.show(io, string("Grammar(N=", g.N, ", T=", g.T, ", P=", g.P, "S=", g.S, ")")) 

