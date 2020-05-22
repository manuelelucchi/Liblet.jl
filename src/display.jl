include("utils.jl")
include("grammar.jl")
include("graph.jl")

escape(x::AbstractString) = replace.(x, r"[\]\[]]" => "")

escape(it::Iterable) = map(x->escape(string(x)), collect(it))

borderedtable(x::AbstractString) = HTML("<style>td, th {border: 1pt solid lightgray !important ;}</style><table>$x</table>")

totable(x::Iterable) = ["\n<tr><th style=\"text-align:left\">$n<td style=\"text-align:left\"><pre>$e</pre>" for (n, e) ∈ enumerate(escape(x))] |> join |> borderedtable

totable(x::Iterable) = ["\n<tr><th style=\"text-align:left\">$n<td style=\"text-align:left\"><pre>$e</pre>" for (n, e) ∈ pairs(escape(x))] |> join |> borderedtable

totable(G::Grammar) = begin
    torow(N) = alternatives(G, N) |> collect |> sort |> (x->map(y->" | " * string(y), x)) |> join |> x->"<th><pre>$N</pre><td style=\"text-align:left\"><pre>$x</pre>"
    rows = [torow(G.S); [torow(N) for N ∈ ((G.N - Set([G.S])) |> collect |> sort)]]
    return join(rows) |> (x->"<tr><tr>$x</table>") |> borderedtable
end

totable(table::CykTable) = begin
    (I, L) = keys(table) |> x->max(x...)
    N = I - if L == 0 1 else I end
    core(l) = [(table[(i, l)] |> x->join(x, " ")) for i ∈ range(1, N - l + 2, step = 1)] |> (x->map(y->"</pre></td><td style=\"text-align:left\"><pre>$y", x)) |> join |> x->"<td style=\"text-align:left\"><pre>$x</pre></td>"
    return [core(l) for l ∈ range(N, L, step = -1)] |> join |> (x->"<tr>$x") |> borderedtable
end

# totable(dod; sort = false, sep = nothing) = nothing

# totable(G, first, follow) = nothing

sidebyside(it::Iterable) = map(x->tosvg(x), it) |> join |> x->HTML("<div>$x</div>")