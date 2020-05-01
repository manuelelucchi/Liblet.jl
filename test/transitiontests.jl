using Test
using Liblet

test_transition_totalorder() = Transition("a", "b", "c") > Transition("a", "b", "b")

test_transition_hash() = begin
    S = Dict(
            Transition("a", "b", "c") => 1,
            Transition("a", "b", "c") => 2
    )
    1 == length(S)
end

test_transition_str() = "frm-label->to" == string(Transition("frm", "label", "to"))

test_transition_lt() = false#"{frm}-label->{to}" == string(Transition(Set(["frm"]), "label", Set(["to"])))

test_transition_set() = "{frm}-label->{to}" == string(Transition(Set(["frm"]), "label", Set(["to"])))

test_transition_tupleofitems() = false#"(A -> •B)-label->(C -> •D)" == Transition([Item("A", ["B"])], "label", [Item("C", ["D"])])

test_transition_wrong_label1() = Transition("frm", 1, "to")

test_transition_wrong_label2() = Transition("frm", "", "to")

test_transition_wrong_from1() = Transition(1, "label", "to")

test_transition_wrong_from2() = Transition("", "label", "to")

test_transition_wrong_from3() = Transition(Set(), "label", "to")

test_transition_wrong_from4() = Transition(Set([""]), "label", "to")

test_transition_wrong_to1() = Transition("frm", "label", 1)

test_transition_wrong_to2() = Transition("frm", "label", "")

test_transition_wrong_to3() = Transition("frm", "label", Set())

test_transition_wrong_to4() = Transition("frm", "label", Set([""]))

# Tests

function runtransitiontests()
    @testset "transition_tests" begin
        @test test_transition_totalorder()
        @test test_transition_hash()
        @test test_transition_str()
        @test test_transition_lt()
        @test test_transition_set()
        @test_throws ArgumentError test_transition_tupleofitems()
        @test_throws MethodError test_transition_wrong_label1()
        @test_throws ArgumentError test_transition_wrong_label2()
        @test_throws MethodError test_transition_wrong_from1()
        @test_throws ArgumentError test_transition_wrong_from2()
        @test_throws ArgumentError test_transition_wrong_from3()
        @test_throws ArgumentError test_transition_wrong_from4()
        @test_throws MethodError test_transition_wrong_to1()
        @test_throws ArgumentError test_transition_wrong_to2()
        @test_throws ArgumentError test_transition_wrong_to3()
        @test_throws ArgumentError test_transition_wrong_to4()
    end
end


runtransitiontests()