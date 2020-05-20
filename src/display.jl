include("utils.jl")
include("grammar.jl")

escape(x::AbstractString) = replace.(x, r"[\]\[]]" => "")

borderedtable(x::AbstractString) = "<style>td, th {border: 1pt solid lightgray !important ;}</style><table>" * x * "</table>"

totable(x::Iterable) = HTML("\n" * string([("<tr><th style=\"text-align:left\">" * string(n) * "<td style=\"text-align:left\"><pre>" * escape("$e") * "</pre>") for (n, e) ∈ enumerate(x)]...))

totable(x::Iterable) = HTML("\n" * string([("<tr><th style=\"text-align:left\">" * string(n) * "<td style=\"text-align:left\"><pre>" * escape("$e") * "</pre>") for (n, e) in pairs(x)]...))

totable(G::Grammar) = begin
    torow(N) = begin
        t = "|" * join(alternatives(G, N) |> collect |> sort)
        "<th><pre>$N</pre><td style=\"text-align:left\"><pre>$t</pre>"
    end
    rows = [torow(G.S); [torow(N) for N ∈ (collect(G.N - Set([G.S])) |> sort)]]
    return HTML(borderedtable("<tr><tr>" * join(rows) * "</table>"))
end