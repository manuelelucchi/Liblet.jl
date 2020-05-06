# Productions

Productions are the most basic thing in languages, translators and compilers.

## Introduction

```@docs 
AbstractProduction
```

## [Production](@id man-production)

```@docs
Production

parseproduction(input::AbstractString, iscontextfree::Bool)

suchthat()

astype0(p::Production)
```

## [Item](@id man-item)

For the purpose of presenting the [Knuth Automaton](https://en.wikipedia.org/wiki/LR_parser#Finite_state_machine) in the context of LR(0) parsing, Item is an extended Production that includes a dot.

```@docs
Item

parseitem(input::AbstractString, iscontexfree::Bool)

astype0(i::Item)

afterdotsymbol(item::Item)

advance(item::Item, x::AbstractString)
```