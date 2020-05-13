using Liblet

# Create an Automaton from a given grammar

A = Automaton(Grammar("""
        S -> a A
        S -> a B
        A -> b B
        A -> b C
        B -> c A
        B -> c C
        C -> a
    """))