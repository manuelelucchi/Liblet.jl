using Liblet
using Test

test_derivation_repr() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    d = Derivation(G)
    for (prod, pos) ∈ [(1, 1), (2, 1), (3, 2)]
        d = next(d, prod, pos)
    end
    d.repr == "S -> A B -> a B -> a b"
end

test_derivation_eq() = begin
    G = Grammar("""
            S -> A B
            A -> a
            B -> b
        """, false)
    d0 = Derivation(G)
    for (prod, pos) ∈ [(1, 1), (2, 1), (3, 2)]
        d0 = next(d0, prod, pos)
    end
    d1 = Derivation(G)
    for (prod, pos) ∈ [(1, 1), (2, 1), (3, 2)]
        d1 = next(d1, prod, pos)
    end
    d0 == d1
end

test_derivation_hash() = begin
    G = Grammar("""
            S -> A B
            A -> a
            B -> b
        """, false)
    d0 = Derivation(G)
    for (prod, pos) ∈ [(1, 1), (2, 1), (3, 2)]
        d0 = next(d0, prod, pos)
    end
    d1 = Derivation(G)
    for (prod, pos) ∈ [(1, 1), (2, 1), (3, 2)]
        d1 = next(d1, prod, pos)
    end
    S = Dict( d0 => 0, d1 => 1)
    length(S) == 1
end

test_derivation_steps() = begin
    G = Grammar("""
            S -> A B
            A -> a
            B -> b
        """, false)
    d = Derivation(G)
    steps = [(1, 1), (2, 1), (3, 2)]
    for (prod, pos) ∈ steps
        d = next(d, prod, pos)
    end
    steps == d.steps
end

test_derivation_byprods() = begin
    G = Grammar("""
            S -> A B
            A -> a
            B -> b
        """)
    d = Derivation(G)
    p = [Production("S", ["A", "B"]), Production("A", ["a"])]
    leftmost(d, p) |> sententialform == ["a", "B"]
end

test_derivation_byprod() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = Derivation(G)
    p = Production("S", ["A", "B"])    
    leftmost(d, p) |> sententialform == ["A", "B"]
end

test_derivation_steps_list() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    k = [(1, 1), (2, 1), (3, 2)]
    d = Derivation(G) 
    d = next(d,k)
    k == steps(d)
end

test_derivation_wrong_step() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    d = Derivation(G)
    steps = [(1, 1), (2, 2)]
    for (prod, pos) ∈ steps
        d = next(d, prod, pos)
    end
end

test_derivation_leftmost() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = Derivation(G) |>
        (x -> leftmost(x, 1)) |>
        (x -> leftmost(x, 2)) |>
        (x -> leftmost(x, 3))
    s = [(1, 1), (2, 1), (3, 2)]
    s == steps(d)
end

test_derivation_leftmost_list() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = leftmost(Derivation(G),[1, 2, 3])
    s = [(1, 1), (2, 1), (3, 2)]
    s == steps(d)
end

test_derivation_leftmost_ncf() = Grammar("S -> s\nT U ->s", false) |> Derivation |> (x -> leftmost(x, 1))

test_derivation_leftmost_allterminals() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    d = Derivation(G) |>
        (x -> leftmost(x, 2)) |>
        (x -> leftmost(x, 5)) |>
        (x -> leftmost(x, 1)) |>
        (x -> leftmost(x, 4)) |>
        (x -> leftmost(x, 3)) |>
        (x -> leftmost(x, 3)) |>
        (x -> leftmost(x, 3))
    leftmost(d, 3)
end

test_derivation_leftmost_wrongsymbol() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    d = Derivation(G) |>
        (x -> leftmost(x, 2)) |>
        (x -> leftmost(x, 5)) |>
        (x -> leftmost(x, 1)) |>
        (x -> leftmost(x, 4)) |>
        (x -> leftmost(x, 3))
    leftmost(d, 4)
end

test_derivation_rightmost() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = Derivation(G) |>
        (x -> rightmost(x, 1)) |>
        (x -> rightmost(x, 3)) |>
        (x -> rightmost(x, 2))
    s = [(1, 1), (3, 2), (2, 1)]
    s == steps(d)
end

test_derivation_rightmost_list() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = Derivation(G) |> x -> rightmost(x,[1, 3, 2])
    s = [(1, 1), (3, 2), (2, 1)]
    s == steps(d)
end

test_derivation_rightmost_ncf() = Grammar("S -> s\nT U ->s", false) |> Derivation |> x -> rightmost(x, 1)

test_derivation_rightmost_allterminals() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    d = Derivation(G) |>
        (x -> rightmost(x, 1)) |>
        (x -> rightmost(x, 4)) |>
        (x -> rightmost(x, 3)) |>
        (x -> rightmost(x, 3))
        rightmost(d, 3)
end

test_derivation_rightmost_wrongsymbol() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    d = Derivation(G) |>
        (x -> rightmost(x, 1)) |>
        (x -> rightmost(x, 4))
    rightmost(d, 4)
end

test_derivation_possible_steps() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    expected = [(2, 1), (3, 2)]
    actual = Derivation(G) |> (x -> next(x, 1, 1)) |> possiblesteps |> collect
    actual == expected
end

test_derivation_possible_steps_prod() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    expected = [(2, 1)]
    actual = Derivation(G) |> (x -> next(x, 1, 1)) |> (x-> possiblesteps(x, prod = 2)) |> collect
    expected == actual
end

test_derivation_possible_steps_pos() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    expected = [(3, 2)]
    actual = Derivation(G) |> (x -> next(x, 1, 1)) |> (x-> possiblesteps(x, pos = 2)) |> collect
    expected == actual
end

# Tests

function runderivationtests()
    @testset "derivation_tests" begin
        @test test_derivation_repr()
        @test test_derivation_eq()
        @test test_derivation_hash()
        @test test_derivation_steps()
        @test test_derivation_byprods()
        @test test_derivation_byprod()
        @test test_derivation_steps_list()
        @test_throws ArgumentError test_derivation_wrong_step()
        @test test_derivation_leftmost()
        @test test_derivation_leftmost_list()
        @test_throws ArgumentError test_derivation_leftmost_ncf()
        @test_throws ArgumentError test_derivation_leftmost_allterminals()
        @test_throws ArgumentError test_derivation_leftmost_wrongsymbol()
        @test test_derivation_rightmost()
        @test test_derivation_rightmost_list()
        @test_throws ArgumentError test_derivation_rightmost_ncf()
        @test_throws ArgumentError test_derivation_rightmost_allterminals()
        @test_throws ArgumentError test_derivation_rightmost_wrongsymbol()
        @test test_derivation_possible_steps()
        @test test_derivation_possible_steps_prod()
        @test test_derivation_possible_steps_pos()
    end
end