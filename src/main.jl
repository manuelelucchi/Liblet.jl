include("derivation.jl")

g = Grammar("""
        Z -> E
        E -> T | E + T | X
        X -> x
        T -> i | ( E )
    """)

d = Derivation(g)
#=d = step(d, 1, 1)
d = step(d, 1, 2)
d = step(d, 2, 3)
print(d.repr)=#

#p = possiblesteps(d)
d = leftmost(d, 1)
print(d.sf)


