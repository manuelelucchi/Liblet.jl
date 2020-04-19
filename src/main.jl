include("derivation.jl")

g = Grammar("S -> aBc
             S -> B
             B -> b")

d = Derivation(g)
#=d = step(d, 1, 1)
d = step(d, 1, 2)
d = step(d, 2, 3)
print(d.repr)=#

#p = possiblesteps(d)
d = leftmost(d, 1)
print(d.sf)


