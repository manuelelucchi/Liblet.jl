using Test
using Liblet

# Constructors

test_production_wrong_lhs() = Production(1, ["a"])

test_production_nonempty_lhs() = Production("",[""])

test_production_wrong_rhs() = Production("a",[1])

test_production_nonemptystr_rhs() = Production("a",["a","","c"])

test_production_nonempty_rhs() = Production("a",[])

test_production_inset() = begin
    P = Production("a", ["b", "c"])
    Q = Production("a", ("b", "c"))
    P == Q
end

test_production_aε() = Production("A", ["a", "ε"])

# Operators

test_production_unpack() = begin
    lhs, rhs = Production("a", ["b", "c"])
    ("a", ["b", "c"]) == (lhs, rhs)
end 

test_production_totalorder() = Production("a", ["b"]) > Production("a", ["a"])

test_production_from_string_cf() = parseproduction("A B -> c", true)

# astype0

test_production_astype0() = Production(["a"], ["b"]) == astype0(Production("a", ["b"]))

# suchthat

test_production_such_that_lhs() = suchthat(left = "X")(Production("X", ["x"]))

test_production_such_that_rhs() = suchthat(right = "x")(Production("X", ["x"]))

test_production_such_that_rhs_len() = suchthat(rightlen = 2)(Production("X", ["x", "y"]))

test_production_such_that_rhs_is_suffix_of() = suchthat(right_is_suffix_of = ["a", "x"])(Production("X", ["x"]))

# Tests

function runproductiontests()    
    @testset "production_tests" begin
        @test_throws ArgumentError test_production_wrong_lhs()
        @test_throws ArgumentError test_production_nonempty_lhs()
        @test_throws ArgumentError test_production_wrong_rhs()
        @test_throws ArgumentError test_production_nonemptystr_rhs()
        @test_throws ArgumentError test_production_nonempty_rhs()
        @test test_production_inset()
        @test_throws ArgumentError test_production_aε()
    
        @test test_production_unpack()
        @test test_production_totalorder()
    
        @test test_production_astype0()
    
        @test test_production_such_that_lhs()
        @test test_production_such_that_rhs()
        @test test_production_such_that_rhs_len()
        @test test_production_such_that_rhs_is_suffix_of()
    end
end