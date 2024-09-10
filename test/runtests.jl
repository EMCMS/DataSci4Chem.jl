using DataSci4Chem
using Test

@testset "DataSci4Chem.jl" begin
    plot(1:10)
    savefig("test.png")
end
