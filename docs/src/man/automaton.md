# Automaton

```@docs
Automaton

Automaton(N::Iterable, T::Iterable, transitions::Iterable, q0::AbstractString, F::Iterable)

Automaton(transitions::AbstractString, F::Union{Nothing,Set} = nothing, q0::Union{Nothing, AbstractString} = nothing)

Automaton(G::Grammar)

δ(a::Automaton, X, x)
```