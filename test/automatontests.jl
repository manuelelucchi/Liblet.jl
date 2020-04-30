using Test
using Liblet

test_transition_unpack() = begin
    f, l, t = Transition("a", "b", "c")
    ("a", "b", "c") == (f, l, t)
end

test_transition_totalorder() = Transition("a", "b", "c") > Transition("a", "b", "b")

test_transition_hash() = begin
    S = Dict(
            Transition("a", "b", "c") => 1,
            Transition("a", "b", "c") => 2
    )
    1 == length(S)
end

test_transition_str() = "frm-label->to" == string(Transition("frm", "label", "to"))

test_transition_lt() = "{frm}-label->{to}" == string(Transition(Set(["frm"]), "label", Set(["to"])))

test_transition_set() = "(A -> •B)-label->(C -> •D)" == string(Transition(Set(["frm"]), "label", Set(["to"])))

test_transition_tupleofitems() = Transition([Item("A", ["B"])], "label", [Item("C", ["D"])])

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

test_automaton_from_grammar() = begin
    A = Automaton(Grammar("""
        S -> a A
        S -> a B
        A -> b B
        A -> b C
        B -> c A
        B -> c C
        C -> a
    """))
    s = "Automaton(N={A, B, C, S, ◇}, T={a, b, c}, transitions=(S-a->A, S-a->B, A-b->B, A-b->C, B-c->A, B-c->C, C-a->◇), F={◇}, q0=S)"
    s == string(A)
end

test_automaton_δ() = begin
    states = Automaton(Grammar("""
        S -> a A
        S -> a B
        A -> b B
        A -> b C
        B -> c A
        B -> c C
        C -> a
    """)) |> x -> δ(x, "S", "a")
    states == Set(["A","B"])
end

test_automaton_from_grammar_fail3() = Automaton(Grammar("S -> a b c"))

test_automaton_from_grammar_fail2a() = Automaton(Grammar("S -> a b"))

test_automaton_from_grammar_fail2b() = Automaton(Grammar("S -> B B"))

test_automaton_from_ε_grammar() = begin
    A = Automaton(Grammar("""
        S -> A
        S -> a B
        A -> a A
        A -> ε
        B -> b B
        B -> b
    """))
    s = "Automaton(N={A, B, S, ◇}, T={a, b}, transitions=(S-ε->A, S-a->B, A-a->A, A-ε->◇, B-b->B, B-b->◇), F={◇}, q0=S)"
    s == string(a)
end

test_automaton_from_string() = begin
    A = Automaton("""
            A, 0, B
            A, 1, F
            B, 0, G
            B, 1, C
            C, 1, C
            D, 0, C
            D, 1, G
            E, 0, H
            E, 1, F
            F, 0, C
            F, 1, G
            G, 0, G
            H, 0, G
            H, 1, C
        """, Set(["C"]))
    s = "Automaton(N={A, B, C, D, E, F, G, H}, T={0, 1}, transitions=(A-0->B, A-1->F, B-0->G, B-1->C, C-1->C, D-0->C, D-1->G, E-0->H, E-1->F, F-0->C, F-1->G, G-0->G, H-0->G, H-1->C), F={C}, q0=A)"
    s == string(A)
end

test_automaton_overlapTN() = Automaton(Set(["A", "B"]), Set(["B", "C"]), [], Set(), "A")

test_automaton_q0N() = Automaton(Set(["A", "B"]), Set(["b", "c"]), [], "X", Set())

test_automaton_FN() = Automaton(Set(["A", "B"]), Set(["b", "c"]), [], "A", Set(["B", "C"]))

# Tests

@testset "production_tests" begin
    @test test_transition_unpack()
    @test test_transition_totalorder()
    @test test_transition_hash()
    @test test_transition_str()
    @test test_transition_lt()
    @test test_transition_set()
    @test_throws ArgumentError test_transition_tupleofitems()
    @test_throws ArgumentError test_transition_wrong_label1()
    @test_throws ArgumentError test_transition_wrong_label2()
    @test_throws ArgumentError test_transition_wrong_from1()
    @test_throws ArgumentError test_transition_wrong_from2()
    @test_throws ArgumentError test_transition_wrong_from3()
    @test_throws ArgumentError test_transition_wrong_from4()
    @test_throws ArgumentError test_transition_wrong_to1()
    @test_throws ArgumentError test_transition_wrong_to2()
    @test_throws ArgumentError test_transition_wrong_to3()
    @test_throws ArgumentError test_transition_wrong_to4()
    @test test_automaton_from_grammar()
    @test test_automaton_δ()
    @test_throws ArgumentError test_automaton_from_grammar_fail3()
    @test_throws ArgumentError test_automaton_from_grammar_fail2a()
    @test_throws ArgumentError test_automaton_from_grammar_fail2b()
    @test test_automaton_from_ε_grammar()
    @test test_automaton_from_string()
    @test_throws ArgumentError test_automaton_overlapTN()
    @test_throws ArgumentError test_automaton_q0N()
    @test_throws ArgumentError test_automaton_FN()
end