include("grammar.jl")

import Base

struct Transition
    from::Union{AbstractString, Set}
    label::AbstractString
    to::Union{AbstractString, Set}
    function Transition(from::Union{AbstractString, Set}, label::AbstractString, to::Union{AbstractString, Set})
        check(s::String)::Bool = true
        check(s::Union{AbstractSet, AbstractArray, Tuple}) = all(map(x -> isa(x, AbstractString), s))

        f = nothing
        l = nothing
        t = nothing

        if check(from)
            f = from
        else
            throw(ArgumentError("The from state is not a nonempty string, or a nonempty set of nonempty strings/items"))
        end

        if check(to)
            t = to
        else
            throw(ArgumentError("The to state is not a nonempty string, or a nonempty set of nonempty strings/items"))
        end

        return new(f, l, t)
    end
end

Base.:<(t1::Transition, t2::Transition) = (t1.from, t1.label, t1.to) < (t2.from, t2.label, t2.to)
Base.:(==)(t1::Transition, t2::Transition) = (t1.from, t1.label, t1.to) == (t2.from, t2.label, t2.to)
Base.hash(t::Transition) = Base.hash((t.from, t.label, t.to))
Base.show(io::IO, e::Transition) = Base.show(io, (e.from * "-" * e.label * "->" * e.to))
Base.iterate(x::Transition, i...) = Base.iterate((x.left, x.right), i...)

function parsetransitions(t::AbstractString)::Array{Transition}
    res = Transition[]
    for t in split(t, '\n')
        if !strip(t)
            continue
        end
        from, label, to = split(t, ',')
        push!(res, Transition(strip(from), strip(label), strip(to)))
    end
    return res
end