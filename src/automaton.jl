import Base
using Printf

include("transition.jl")

DIAMOND = "◇"

"""
This type represents a (*nondeterministic*) *finite automaton*, defined as a tuple ``A=(N,T,transitions,q0,F)``
"""
struct Automaton
    "The states of the automaton."
    N::Set
    "The transition labels."
    T::Set    
    "The transition of the automata."
    transitions::Array
    "The starting state of the automation"
    q0::AbstractString
    "The set of *final* states."
    F::Set
    """
        Automaton(N::Iterable, T::Iterable, transitions::Iterable, q0::AbstractString, F::Iterable)
    Builds an [`Automaton`](@ref) obtained from the given components.
    """
    function Automaton(N::Iterable, T::Iterable, transitions::Iterable, q0::AbstractString, F::Iterable)
        N = isa(N, Set) ? N : Set(N)
        T = isa(T, Set) ? T : Set(T)
        F = isa(F, Set) ? F : Set(F)
        transitions = if all(x->isa(x, Transition), transitions) collect(transitions) else throw(ArgumentError("There are non-transitions in the transitions set")) end
        if ~isempty(N ∩ T) throw(ArgumentError("The set of states and input symbols are not disjoint, but have in common.")) end
        if q0 ∉ N throw(ArgumentError("The specified q0 is not a state.")) end
        if F ⊈ N throw(ArgumentError("The accepting states in F are not states.")) end
        bad_trans = [t for t ∈ transitions if t.from ∉ N || t.to ∉ N || t.label ∉ (T ∪ Set(["ε"]))]
        if ~isempty(bad_trans) throw(ArgumentError("The following transitions contain states or symbols that are neither states nor input symbols")) end
        return new(N, T, transitions, q0, F)
    end
end

"""
    Automaton(transitions::AbstractString, F::Union{Nothing,Set} = nothing, q0::Union{Nothing, AbstractString} = nothing)::Automaton
Builds an [`Automaton`](@ref) obtained from the given transitions.
"""
function Automaton(transitions::AbstractString, F::Union{Nothing,Set} = nothing, q0::Union{Nothing, AbstractString} = nothing)::Automaton
    transitions = parsetransitions(transitions)
    if q0 === nothing q0 = transitions[1].from end
    if F === nothing F = Set() end

    N = Set(map(x::Transition -> x.from, transitions) ∪ map(x::Transition -> x.to, transitions))
    T = Set(map(x::Transition -> x.label, transitions)) - "ε"
    return Automaton(N, T, transitions, q0, F)
end

"""
    Automaton(G::Grammar)::Automaton 
Builds the [`Automaton`](@ref) corresponding to the given *regular* [`Grammar`](@ref).
"""
function Automaton(G::Grammar)::Automaton 
    transitions = []

    for P ∈ G.P
        if length(P.right) > 2 throw(ArgumentError("Production has more than two symbols on the left-hand side")) end
        if length(P.right) == 2
            A = P.left
            a = P.right[1]
            B = P.right[2]
            if ~(a ∈ G.T && B ∈ G.N) throw(ArgumentError("Production right-hand side is not of the aB form")) end
            push!(transitions, Transition(A, a, B))
        elseif P.right[1] ∈ G.N
            push!(transitions, Transition(P.left, "ε", P.right))
        else 
            push!(transitions, Transition(P.left, P.right[1], DIAMOND))
        end
    end

    return Automaton(G.N ∪ Set([DIAMOND]), G.T, transitions, G.S, Set([DIAMOND]))
end

### Functions ###

"""
    δ(a::Automaton, X, x)
The transition function.

This function returns the set of states reachable from the given state and input symbol.
"""
δ(a::Automaton, X, x) = Set([t.to for t ∈ a.transitions if t.from == X && t.label == x])

### Operators ###

Base.show(io::IO, a::Automaton) = Base.show(io, @sprintf "Automaton(N=%s, T=%s, transitions=%s, F=%s, q0=%s)" a.N a.T a.F a.transitions a.q0) #TODO
