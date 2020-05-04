using Test
using Liblet

test_item_wrong_lhs() = Item(1, ["a"])

test_item_neg_pos() = Item("A", ["B"], -1)

test_item_wrong_pos() = Item("A", ["B"], 2)

test_item_inset() = begin
    P = Item("a",["b","c"])
    Q = Item("a",["b", "c"])
    s = Set()
    push!(s, P)
    push!(s, Q)
    length(s) == 1
end

test_item_totalorder() = Item("A",["B","C"],2) > Item("a",["b","c"],1)

test_item_advance() = Item("A", ("x", "B"), 1) == advance(Item("A", ("x", "B")),"x")

test_item_notadvance() = advance(Item("A",["B","C"]),"x") == nothing

test_item_symbol_after_dot() = "B" == (Item("A",["x","B"],1) |> afterdotsymbol)

test_item_nosymbol_after_dot() = (Item("A", ("B", "C"), 2) |> afterdotsymbol) == nothing

function runitemtests()
    @testset "item_tests" begin
        # constructors
        @test_throws ArgumentError test_item_wrong_lhs()
        @test_throws ArgumentError test_item_neg_pos()
        @test_throws ArgumentError test_item_wrong_pos()
        @test test_item_inset()
        @test test_item_totalorder()

        # advance
        @test test_item_advance()
        @test test_item_notadvance()

        # afterdotsymbol
        @test test_item_symbol_after_dot()
        @test test_item_nosymbol_after_dot()
    end
end