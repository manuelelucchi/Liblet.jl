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
            "Grammars & Derivations" => "tutorials/derivations.md",
            "Automatons" => "tutorials/automatons.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/manuelelucchi/Liblet.jl.git",
    branch="gh-pages"
)