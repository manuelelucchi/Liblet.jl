using Test
using Liblet

# Constructor

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
    s == string(A)
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

test_automaton_overlapTN() = Automaton(Set(["A", "B"]), Set(["B", "C"]), [], "A",  Set())

test_automaton_q0N() = Automaton(Set(["A", "B"]), Set(["b", "c"]), [], "X", Set())

test_automaton_FN() = Automaton(Set(["A", "B"]), Set(["b", "c"]), [], "A", Set(["B", "C"]))

# δ

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

# Tests

function runautomatontests()
    @testset "automaton_tests" begin
        #@test test_automaton_from_grammar()
        @test test_automaton_δ()
        @test_throws ArgumentError test_automaton_from_grammar_fail3()
        @test_throws ArgumentError test_automaton_from_grammar_fail2a()
        @test_throws ArgumentError test_automaton_from_grammar_fail2b()
        #@test test_automaton_from_ε_grammar()
        #@test test_automaton_from_string()
        @test_throws ArgumentError test_automaton_overlapTN()
        @test_throws ArgumentError test_automaton_q0N()
        @test_throws ArgumentError test_automaton_FN()
    end    
end