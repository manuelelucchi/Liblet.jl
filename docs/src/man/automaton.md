# [Automaton](@id man-automaton)

Using these types and methods, you can build a Finite State Automaton.

```@docs
Automaton

Automaton(transitions::AbstractString, F::Union{Nothing,Set} = nothing, q0::Union{Nothing, AbstractString} = nothing)

Automaton(G::Grammar)

δ(a::Automaton, X, x)
```