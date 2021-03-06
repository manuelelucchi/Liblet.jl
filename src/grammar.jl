import Base

include("production.jl")

"""
A grammar, represented as a tuple ``G=(N,T,P,S)``
"""
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

"""
    Grammar(N::Set, T::Set, P::Array, S::AbstractString)::Grammar
Builds a [`Grammar`](@ref) obtained from the given string of productions.
"""
function Grammar(N, T, P, S) 
    cf = all(x -> isa(x.left, AbstractString), P)
    if (N ∩ T) ≠ Set()
        throw(ArgumentError("The set of terminals and nonterminals are not disjoint, but have " * string(collect(N ∩ T)) * " in common"))
    end
    if S ∉ N
        throw(ArgumentError("The start symbol is not a nonterminal."))
    end
    if cf
        badprods = [p for p ∈ P if p.left ∉ N]
        if !isempty(badprods)
            throw(ArgumentError("The following productions have a left-hand side that is not a nonterminal: " * string(badprods)))
        end
    end
    badprods = [p for p ∈ P if (Set(astype0(p).left) ∪ Set(p.right)) ⊈ (N ∪ T ∪ Set(["ε"]))] 
    if ~isempty(badprods)
        throw(ArgumentError("The following productions contain symbols that are neither terminals or nonterminals: " * string(badprods)))
    end
    Grammar(N, T, P, S, cf)
end

"""
    Grammar(prods::AbstractString, iscontextfree = true)::Grammar
Builds a [`Grammar`](@ref) obtained from the given string of productions.
"""
function Grammar(prods::AbstractString, iscontextfree = true)::Grammar
    P = parseproduction(prods, iscontextfree)
    S = nothing
    N = nothing
    T = nothing
    if iscontextfree
        S = P[1].left
        N = Set(map(x -> x.left, P))
        T = Set(vcat(map(x -> x.right, P)...)) - N - "ε"
    else
        S = P[1].left[1]
        symbols = Set(vcat(map(x -> x.left, P)...)) ∪ Set(vcat(map(x -> x.right, P)...))
        N = Set(filter(x -> isuppercase(x[1]), symbols))
        T = symbols - N - "ε"
    end
    G = Grammar(N, T, P, S)
    if iscontextfree
        if ~G.iscontextfree 
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
alternatives(g::Grammar, N::Union{AbstractString, Iterable})::Array = [P.right for P ∈ g.P if P.left == (isa(N,Iterable) ? collect(N) : N)]

"""
    restrict(g::Grammar, symbols::Set)
Returns a [`Grammar`](@ref) using only the given symbols.
"""
restrict(g::Grammar, symbols::Set) = if g.S ∉ symbols throw(ArgumentError("The start symbol must be present among the symbols to keep.")) else Grammar(g.N ∩ symbols, g.T ∩ symbols, [P for P ∈ g.P if (Set([P.left]) ∪ Set(P.right)) ≤ symbols], g.S) end

### Operators ###

Base.:(==)(x::Grammar, y::Grammar) = (x.N, x.T, sort(x.P), x.S) == (y.N, y.T, sort(y.P), y.S)

Base.hash(g::Grammar) = Base.hash((g.N, g.T, sort(g.P), g.S))

Base.show(io::IO, g::Grammar) = Base.show(io, string("Grammar(N=", g.N, ", T=", g.T, ", P=", g.P, "S=", g.S, ")")) 

