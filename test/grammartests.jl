using Test
using Liblet

# restrict

function test_grammar_restrict_to()
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
    print((Gt, Gr))
    Gt == Gr
end

# Tests

@testset "grammar_tests" begin
    @test test_grammar_restrict_to()
end