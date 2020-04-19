import Base

include("production.jl")

struct Grammar
    N::Set
    T::Set
    P::Array
    S::AbstractString
    iscontextfree::Bool
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
        badprods = [] #Todo
        if !isempty(badprods)
            throw(ArgumentError("Error: Bad Productions"))
        end
        new(N, T, P, S, cf)
    end
    Grammar(productions::AbstractString, iscontextfree = true) = parsegrammar(productions, iscontextfree)
end

function parsegrammar(prods::AbstractString, iscontextfree = true)::Grammar
    P = parseproduction(prods, iscontextfree)
    S = nothing
    N = nothing
    T = nothing
    if iscontextfree
        S = P[1].left
        N = Set(map(x -> x.left, P))
        T = setdiff(Set(vcat(map(x -> x.right, P)...)), N) # Da sottrarre ϵ
    else
        S = P[1].left[1]
        symbols = union(Set(vcat(map(x -> x.left, P))), Set(vcat(map(x -> x.right, P))))
        N = Set(filter(x -> isuppercase(x[1]), symbols))
        T = setdiff(symbols, N) # da sottrarre ϵ
    end
    G = Grammar(N, T, P, S)
    if iscontextfree
        if !G.iscontextfree 
            throw(ArgumentError("The resulting grammar is not context-free, even if so requested."))
        end
    end
    return G
end

alternatives(g::Grammar, N::Array) = [P.right for P in g.P if P.left == N]

restrict(g::Grammar, symbols::Set) = throw(ErrorException("Method not implemented")) #Grammar(intersect(g.N, symbols), intersect(g.T, symbols), [P for P in g.P if union(Set([P.left]), Set)], g.S)

Base.:(==)(x::Grammar, y::Grammar) = (x.N, x.T, sort(x.P), x.S) == (y.N, y.T, sort(x.S), y.S)

Base.hash(g::Grammar) = Base.hash((g.N, g.T, sort(g.P), g.S))

Base.show(io::IO, g::Grammar) = Base.show(io, string("Grammar(N=", g.N, ", T=", g.T, ", P=", g.P, "S=", g.S, ")")) 

