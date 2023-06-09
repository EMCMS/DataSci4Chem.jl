using Documenter, DataSci4Chem

makedocs(modules = [Documenter, DataSci4Chem],
    build = "build",
    clean = true,
    sitename="DataSci4Chem.jl",
    pages = [
        "Home" => "index.md"
        ]
    )

deploydocs(
        repo = "github.com/EMCMS/DataSci4Chem.jl.git",
        target = "build",
        branch = "gh-pages",
        #push_preview = true,
)


# include("/Users/saersamanipour/Desktop/dev/pkgs/DataSci4Chem.jl/docs/make.jl") 