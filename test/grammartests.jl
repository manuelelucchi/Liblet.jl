using Test
using Liblet

test_production_wrong_lhs() = Production(1, ["a"])

test_production_nonempty_lhs() = Production("",[""])

test_production_wrong_rhs() = Production("a",[1])

test_production_nonemptystr_rhs() = Production("a"["a","","c"])

test_production_nonempty_rhs() = Production("a",[])

test_production_such_that_lhs() = suchthat(left = "X")(Production("X", ["x"]))

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


@testset "production_tests" begin
    @test_throws ArgumentError test_production_wrong_lhs()
    #@test_throws ArgumentError test_production_nonempty_lhs()
    #@test_throws ArgumentError test_production_wrong_rhs()
    #@test_throws ArgumentError test_production_nonemptystr_rhs()
    #@test_throws ArgumentError test_production_nonempty_rhs()

    @test test_grammar_restrict_to()
    @test test_production_such_that_lhs()
end