include("utils.jl")
include("grammar.jl")
include("graph.jl")

escape(x::AbstractString) = replace.(x, r"[\]\[]]" => "")

escape(it::Iterable) = map(x->escape(string(x)), collect(it))

borderedtable(x::AbstractString) = html"<style>td, th {border: 1pt solid lightgray !important ;}</style><table>$x</table>"

totable(x::Iterable) = ["\n<tr><th style=\"text-align:left\">$n<td style=\"text-align:left\"><pre>$e</pre>" for (n, e) ∈ enumerate(escape(x))] |> join |> borderedtable

totable(x::Iterable) = ["\n<tr><th style=\"text-align:left\">$n<td style=\"text-align:left\"><pre>$e</pre>" for (n, e) ∈ pairs(escape(x))] |> join |> borderedtable

totable(G::Grammar) = begin
    torow(N) = begin
        t = alternatives(G, N) |> collect |> sort |> (x->map(y->" | " * string(y), x)) |> join
        "<th><pre>$N</pre><td style=\"text-align:left\"><pre>$t</pre>"
    end
    rows = [torow(G.S); [torow(N) for N ∈ ((G.N - Set([G.S])) |> collect |> sort)]]
    return join(rows) |> (x->"<tr><tr>$x</table>") |> borderedtable
end

totable(table::CykTable) = begin
    (I, L) = keys(table) |> max
    N = I - if L == 0 1 else I end
    return ""# [(() for i ∈ range(1, N - l + 2, step = 1)) for l ∈ range(N, L - 1, step = -1)] |> join |> (x->"<tr>$x") |> borderedtable # borderedtable("<tr>" * join(["<tr><td style=\"text-align:left\"><pre>" * join(["</pre></td><td style=\"text-align:left\"><pre>" * table[(i,l)] for i ∈ range(1,(N-l+2)) for l ∈ range(N, L - 1, step = -1)]))
end

sidebyside(it::Iterable) = map(x->tosvg(x), it) |> join |> x->HTML("<div>$x</div>")