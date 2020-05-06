# [Grammar](@id man-grammar)

```@docs

Grammar

Grammar(N, T, P, S) 

Grammar(prods::AbstractString, iscontextfree = true)

alternatives(g::Grammar, N::Union{AbstractString, Iterable})

restrict(g::Grammar, symbols::Set)

```