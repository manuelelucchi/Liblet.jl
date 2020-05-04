# Productions

## Introduction

## AbstractProduction

```@docs 
AbstractProduction
```

## Production

```@docs
Production

parseproduction(input::AbstractString, iscontextfree::Bool)

suchthat()

astype0(p::Production)
```

## Item

```@docs
Item

parseitem(input::AbstractString, iscontexfree::Bool)::Array{Item}

astype0(i::Item)

afterdotsymbol(item::Item)

advance(item::Item, x::AbstractString)
```