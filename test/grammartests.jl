using Test
using Liblet

# Operators

test_grammar_eq() = Grammar("S -> A B | B\nA -> a\nB -> b") == Grammar("S -> B | A B\nB -> b\nA -> a")

test_grammar_hash() = begin
    S = Dict(
        Grammar("S -> A B | B\nA -> a\nB -> b") => 1,
        Grammar("S -> B | A B\nB -> b\nA -> a") => 2
    )
    length(S) == 1
end

test_grammar_nondisjoint() = Grammar(Set(["S", "A"]),Set(["A", "a"]), [], "S")

test_grammar_wrongstart() = Grammar(Set(["T", "A"]),Set(["a"]), [], "S")

test_grammar_cf() = Grammar("S -> T U\nT -> t\nU -> u").iscontextfree

test_grammar_not_cf() = Grammar("S -> T U\nT x -> t\nT U -> u", false).iscontextfree

test_grammar_wrong_cf() = Grammar(Set(["S"]), Set(["s"]), [Production("S", ["s"]), Production("T", ["s"])], "S")

test_grammar_extrasymbol() = Grammar(Set(["S"]), Set(["s"]), [Production("S", ["s"]), Production(["S"], ["s", "t"])], "S")

test_grammar_from_to_string() = begin
    G = Grammar("""
        Z -> E
        E -> T | E + T
        T -> i | ( E )
    """)
    s = "" # to finish
    s == string(G)
end

# restrict

test_grammar_restrict_to() = begin
    G = Grammar("""
        Z -> E
        E -> T | E + T | X
        X -> x
        T -> i | ( E )
    """)
    Gr = Grammar("""
        Z -> E
        E -> T | E + T
        T -> i | ( E )
    """)
    symbols = G.T ∪ G.N - Set(["X", "x"])
    Gt = restrict(G, symbols)
    Gt == Gr
end

test_grammar_restrict_to_no_start() = begin
    G = Grammar("""
    Z -> E
    E -> T | E + T | X
    X -> x
    T -> i | ( E )
    """)
    restrict(G, (G.T ∪ G.N) - Set(["Z"]))
end

# alternative 

test_alternatives() = begin
    G = Grammar("""
    Z -> E k
    E -> T | E + T
    T -> i | ( E )
    """)
    expected = Set([["T"], ["E", "+", "T"]])
    Set(alternatives(G, "E")) == expected
end

# Tests

function rungrammartests()    
    @testset "grammar_tests" begin
        @test test_grammar_eq()
        #@test test_grammar_hash()
        @test_throws ArgumentError test_grammar_nondisjoint()
        @test_throws ArgumentError test_grammar_wrongstart()
        @test test_grammar_cf()
        @test !test_grammar_not_cf()
        @test_throws ArgumentError test_grammar_wrong_cf()
        @test_throws ArgumentError test_grammar_extrasymbol()

        # restrict
        @test test_grammar_restrict_to()
        @test_throws ArgumentError test_grammar_restrict_to_no_start()
    
        # alternative 
        @test test_alternatives()
    end
end

rungrammartests()