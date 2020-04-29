using Liblet
using Test

test_derivation_repr() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    d = Derivation(G)
    for (p, pros) ∈ [(0, 0), (1, 0), (2, 1)]
        d = next(d, p, pros)
    end
    string(d) == "S -> A B -> a B -> a b"
end

test_derivation_eq() = begin
    G = Grammar("""
            S -> A B
            A -> a
            B -> b
        """, false)
    d0 = Derivation(G)
    for (prod, pos) ∈ [(0, 0), (1, 0), (2, 1)]
        d0 = next(d0, prod, pos)
    end
    d1 = Derivation(G)
    for (prod, pos) ∈ [(0, 0), (1, 0), (2, 1)]
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
    for (prod, pos) ∈ [(0, 0), (1, 0), (2, 1)]
        d0 = next(d0, prod, pos)
    end
    d1 = Derivation(G)
    for (prod, pos) ∈ [(0, 0), (1, 0), (2, 1)]
        d1 = next(d1, prod, pos)
    end
    S = Dict( d0 => 0, d1 => 1)
    len(S) == 1
end

test_derivation_steps() = begin
    G = Grammar("""
            S -> A B
            A -> a
            B -> b
        """, false)
        d = Derivation(G)
        steps = [(0, 0), (1, 0), (2, 1)]
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
    p = Production("S", ["A", "B"]), Production("A", ["a"])
    (leftmost ∘ sententialform)(p) == ["a", "B"]
end

test_derivation_byprod() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = Derivation(G)
    p = Production("S", ["A", "B"])    
    (leftmost ∘ sententialform)(p) == ["A", "B"]
end

test_derivation_steps_list() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    s = [(0, 0), (1, 0), (2, 1)]
    d = next(Derivation(G),s)
    s == steps(d)
end

test_derivation_wrong_step() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    d = Derivation(G)
    steps = ((0, 0), (1, 1))
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
    d = Derivation(G) 
    #d = leftmost(d,[0, 1, 2]) todo
    s = [(0, 0), (1, 0), (2, 1)]
    s == steps(d)
end

test_derivation_leftmost_list() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = leftmost(Derivation(G),[0, 1, 2])
    s = [(0, 0), (1, 0), (2, 1)]
    s == steps(d)
end

test_derivation_leftmost_ncf() = leftmost(Derivation(Grammar("S -> s\nT U ->s", false)), 0)

test_derivation_leftmost_allterminals() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    #d = Derivation(G).leftmost(1).leftmost(4).leftmost(0).leftmost(3).leftmost(2).leftmost(2).leftmost(2)
end

test_derivation_leftmost_wrongsymbol() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    #d = Derivation(G).leftmost(1).leftmost(4).leftmost(0).leftmost(3).leftmost(2)
    leftmost(d, 3)
end

test_derivation_rightmost() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = Derivation(G).rightmost(0).rightmost(2).rightmost(1)
    s = [(0, 0), (2, 1), (1, 0)]
    s == steps(d)
end

test_derivation_rightmost_list() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """)
    d = rightmost(Derivation(G),[0, 2, 1])
    s = [(0, 0), (2, 1), (1, 0)]
    s == steps(d)
end

test_derivation_rightmost_ncf() = rightmost(Derivation(Grammar("S -> s\nT U ->s", false)), 0)

test_derivation_rightmost_allterminals() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    #d = Derivation(G).rightmost(1).rightmost(4).rightmost(0).rightmost(3).rightmost(2).rightmost(2).rightmost(2)
end

test_derivation_rightmost_wrongsymbol() = begin
    G = Grammar("""
    E -> M | A | n
    M -> E * E
    A -> E + E
    """)
    #d = Derivation(G).rightmost(1).rightmost(4).rightmost(0).rightmost(3).rightmost(2)
    rightmost(d, 3)
end

test_derivation_possible_steps() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    expected = [(1, 0), (2, 1)]
    actual = collect(possiblesteps(next(Derivation(G),[0,0])))
    actual == expected
end

test_derivation_possible_steps_prod() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    expected = [(1, 0)]
    actual = collect(possiblesteps(next(Derivation(G),[0,0]), 1))
    expected == actual
end

test_derivation_possible_steps_pos() = begin
    G = Grammar("""
        S -> A B
        A -> a
        B -> b
    """, false)
    expected = [(2, 1)]
    actual = collect(possiblesteps(next(Derivation(G),[0,0]), nothing, 1))
    expected == actual
end

# Tests

@testset "derivation_tests" begin
    @test test_derivation_repr()
    @test test_derivation_eq()
    @test test_derivation_hash()
    @test test_derivation_steps()
    @test test_derivation_byprods()
    @test test_derivation_byprod()
    @test test_derivation_byprod()
    @test test_derivation_steps_list()
    @test_throws ArgumentError test_derivation_wrong_step()
    #@test_throws ArgumentError test_derivation_leftmost() todo
    @test test_derivation_leftmost_list()
    @test_throws ArgumentError test_derivation_leftmost_ncf()
    #@test_throws ArgumentError test_derivation_leftmost_allterminals() todo
    #@test_throws ArgumentError test_derivation_leftmost_wrongsymbol() todo
    #@test test_derivation_rightmost() todo
    @test test_derivation_rightmost_list()
    @test_throws ArgumentError test_derivation_rightmost_ncf()
    @test_throws ArgumentError test_derivation_rightmost_allterminals()
    @test_throws ArgumentError test_derivation_rightmost_wrongsymbol()
    @test test_derivation_possible_steps()
    @test test_derivation_possible_steps_prod()
    @test test_derivation_possible_steps_pos()
end