using Liblet

# Context Dependant Type 0 Grammar

G = Grammar("""
    Sentence -> Name | List End
    List -> Name | Name , List
    Name -> tom | dick | harry
    , Name End -> and Name
    """, false)

for p ∈ G.P println(p) end

d = Derivation(G)

println("\nSentential Form: " * string(d))

d = d |> 
    (x -> next(x, 2, 1)) |> 
    (x -> next(x, 4, 1)) |>
    (x -> next(x, 4, 3)) |>
    (x -> next(x, 3, 5)) |>
    (x -> next(x, 8, 4)) |>
    (x -> next(x, 5, 1)) |>
    (x -> next(x, 6, 3)) |>
    (x -> next(x, 7, 5))

println("\nSentential Form after 8 steps: " * string(d))