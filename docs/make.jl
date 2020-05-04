using Documenter, Liblet

makedocs(
    modules = [Liblet],
    clean = false,
    sitename="Liblet.jl",
    repo = "https://github.com/manuelelucchi/Liblet.jl.git",
    authors = "Manuele Lucchi",
    pages = [
        "Home" => "index.md",
        "Getting Started" => "gettingstarted.md",
        "Manual" => [
            "Productions" => "man/production.md",
            "Grammar" => "man/grammar.md",
            "Derivation" => "man/derivation.md",
            "Transition" => "man/transition.md",
            "Automaton" => "man/automaton.md"
        ],
        "Tutorials" => [

        ]
    ]
)

deploydocs(
    repo = "https://github.com/manuelelucchi/Liblet.jl.git",
    target = "build",
    julia = "1.4",
    deps = nothing,
    make = nothing
)