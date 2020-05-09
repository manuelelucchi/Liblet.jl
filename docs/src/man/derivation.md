# [Derivation](@id man-derivation)

You can build derivations from a given Grammar.

```@docs

Derivation

Derivation(G::Grammar)

next(d::Derivation, prod::Int, pos::Int)

next(d::Derivation, prod::Production, pos::Int)

next(d::Derivation, prod::AbstractArray{Tuple{Int, Int}})

leftmost(d::Derivation, prod::Int)

leftmost(d::Derivation, prod::Production)

leftmost(d::Derivation, prod::AbstractArray{Production})

leftmost(d::Derivation, prod::AbstractArray{Int})

rightmost(d::Derivation, prod::Int)

rightmost(d::Derivation, prod::Production)

rightmost(d::Derivation, prod::AbstractArray{Int})

rightmost(d::Derivation, prod::AbstractArray{Production})

possiblesteps(d::Derivation; prod::Union{Int, Nothing} = nothing, pos::Union{Int, Nothing} = nothing)

sententialform(d::Derivation)

steps(d::Derivation)

```