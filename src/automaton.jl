import Base
using Printf

include("transition.jl")

"""
An automaton.

This class represents a (*nondeterministic*) *finite automaton*.
"""
struct Automaton
    "The states of the automaton."
    N::Set
    "The transition labels."
    T::Set
    "The set of *final* states."
    F::Set
    "The transition of the automata."
    transitions::Array
    "The starting state of the automation"
    q0::AbstractString
end

### Constructors ###

"""
Builds an automaton obtained from the given components.
"""
function Automaton(N::Iterable, T::Iterable, F::Iterable, transitions::Iterable, q0::AbstractString)
    N = isa(N, Set) ? N : Set(N)
    T = isa(T, Set) ? T : Set(T)
    F = isa(F, Set) ? F : Set(F)
    transitions = collect(transitions)
    return Automaton(N, T, F, transitions, q0)
end

"""
Builds an automaton obtained from the given transitions.
"""
function Automaton(F::Set, transitions::Array, q0::NullableAbstractString = nothing)::Automaton
    transitions = parsetransitions(transitions)
    if q0 === nothing
        q0 = transitions[1].from
    end

    N = Set(map(x::Transition -> x.from, transitions) ∪ map(x::Transition -> x.to, transitions))
    T = Set(map(x::Transition -> x.label, transitions)) - ϵ
    return Automaton(N, T, F, transitions, q0)
end

"""
Builds the automaton corresponding to the given *regular grammar*.
"""
function Automaton(G::Grammar)::Automaton 
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

### Functions ###

"""
    δ(a::Automaton, X, x)
The transition function.

This function returns the set of states reachable from the given state and input symbol.
"""
δ(a::Automaton, X, x) = Set([Z for (Y, y, Z) in a.transitions if X == Y && y==x])

### Operators ###

Base.show(io::IO, a::Automaton) = Base.show(io, @sprintf "Automaton(N=%s, T=%s, transitions=%s, F=%s, q0=%s)" a.N a.T a.F a.transitions a.q0) #TODO
