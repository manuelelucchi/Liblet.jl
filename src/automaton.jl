import Base
using Printf

include("transition.jl")

struct Automaton
    N::Set
    T::Set
    F::Set
    transitions::Array
    q0::AbstractString
    function Automaton(N::Iterable, T::Iterable, F::Iterable, transitions::Iterable, q0::AbstractString)
        N = isa(N, Set) ? N : Set(N)
        T = isa(T, Set) ? T : Set(T)
        F = isa(F, Set) ? F : Set(F)
        transitions = collect(transitions)
        return new(N, T, F, transitions, q0)
    end
    Automaton(F::Set, transitions::Array, q0::NullableAbstractString) = automaton(F, transitions, q0)
    Automaton(G::Grammar) = automaton(G)
end

Base.show(io::IO, a::Automaton) = Base.show(io, @sprintf "Automaton(N=%s, T=%s, transitions=%s, F=%s, q0=%s)" a.N a.T a.F a.transitions a.q0) #TODO

δ(a::Automaton, X, x) = Set([Z for (Y, y, Z) in a.transitions if X == Y && y==x])

function automaton(N::Iterable, T::Iterable, F::Iterable, transitions::Iterable, q0::AbstractString)
    N = isa(N, Set) ? N : Set(N)
    T = isa(T, Set) ? T : Set(T)
    F = isa(F, Set) ? F : Set(F)
    transitions = collect(transitions)
    return Automaton(N, T, F, transitions, q0)
end

function automaton(F::Set, transitions::Array, q0::NullableAbstractString = nothing)::Automaton
    transitions = parsetransitions(transitions)
    if q0 === nothing
        q0 = transitions[1].from
    end

    N = Set(map(x::Transition -> x.from, transitions) ∪ map(x::Transition -> x.to, transitions))
    T = Set(map(x::Transition -> x.label, transitions)) - ϵ
    return Automaton(N, T, F, transitions, q0)
end

function automaton(G::Grammar)::Automaton 
    transitions = []
    diamond = ""

    for P in G.P
        if length(P.right) > 2
        end
        if length(P.right) == 2
        elseif P.right[1] in G.N
        else 
        end
    end

    return Automaton(G.N ∪ Set([diamond]), G.T, transitions, Set([diamond]), G.S)
end