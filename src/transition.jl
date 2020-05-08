include("grammar.jl")

import Base

"""
This type represents an [`Automaton`](@ref) transition. It has a `from` starting
*state* and a `to` destination *state* and a `label`
"""
struct Transition
    "The starting state(s) of the transition"
    from::Union{AbstractString, Set}
    "The label of the transition"
    label::AbstractString
    "The destination starte(s) of the transition"
    to::Union{AbstractString, Set}
    """
        Transition(from::Union{AbstractString, Iterable}, label::AbstractString, to::Union{AbstractString, Iterable})
    Build a transition based on the given states.

    # Examples
    ```julia-repl
    julia> t = Transition("from","label","to")
    julia> t
    from-label->to
    ```
    """
    function Transition(from::Union{AbstractString, Iterable}, label::AbstractString, to::Union{AbstractString, Iterable})
        check(s::AbstractString)::Bool = ~isempty(s)
        check(s::AbstractProduction)::Bool = true
        check(s)::Bool = false
        check(s::Iterable) = all(x -> check(x), Set(collect(s))) && ~isempty(s)
    
        f = nothing
        l = nothing
        t = nothing
    
        if check(from)
            f = isa(from, Iterable) ? Set(collect(from)) : from
        else
            throw(ArgumentError("The from state is not a nonempty string, or a nonempty set of nonempty strings/items"))
        end

        if check(label)
            l = label
        else
            throw(ArgumentError("The label is not a nonempty string"))
        end
    
        if check(to)
            t = isa(to, Iterable) ? Set(collect(to)) : to
        else
            throw(ArgumentError("The to state is not a nonempty string, or a nonempty set of nonempty strings/items"))
        end
    
        return new(f, l, t)
    end
end

### Functions ###

"""
    parsetransitions(t::AbstractString)::Array{Transition}
Builds an array of [`Transition`](@ref) obtained from the given string.
"""
function parsetransitions(t::AbstractString)::Array{Transition}
    res = Transition[]
    for t ∈ split(t, '\n')
        if isempty(strip(t))
            continue
        end
        from, label, to = split(t, ',')
        push!(res, Transition(strip(from), strip(label), strip(to)))
    end
    return res
end

### Operators ###

Base.:<(t1::Transition, t2::Transition) = (t1.from, t1.label, t1.to) < (t2.from, t2.label, t2.to)
Base.:(==)(t1::Transition, t2::Transition) = (t1.from, t1.label, t1.to) == (t2.from, t2.label, t2.to)
Base.:>(t1::Transition, t2::Transition) = !(t1 == t2 || t1 < t2)
Base.hash(t::Transition) = Base.hash((t.from, t.label, t.to))
Base.show(io::IO, e::Transition) = Base.show(io, string(e.from, "-", e.label, "->", e.to))
Base.iterate(x::Transition, i...) = Base.iterate((x.from, x.label, x.to))