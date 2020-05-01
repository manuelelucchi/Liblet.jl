include("grammartests.jl")
include("productiontests.jl")
include("transitiontests.jl")
include("automatontests.jl")

rungrammartests()
runproductiontests()
runautomatontests()
runtransitiontests()