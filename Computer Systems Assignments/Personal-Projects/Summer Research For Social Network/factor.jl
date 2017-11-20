Pkg.add("JLD")
using JLD

function solve(F::LUfactors, b)
    L, U, p, q, Rs = F.L, F.U, F.p, F.q, F.Rs
    x = U \ ( L \ ((Rs.*b)[p,]) )
    ipermute!(x,q)
    return x
end


type LUfactors
    L ::SparseMatrixCSC{Float64,Int64}
    U ::SparseMatrixCSC{Float64,Int64}
    p ::Array{Int64,1}
    q ::Array{Int64,1}
    Rs::Array{Float64,1}
end

# A = sprand(5,5,0.5) + speye(5)
# b = rand(5)
# F = lufact(A)
# L, U, p, q, Rs = F[:(:)]
# Fs = LUfactors(L,U,p,q,Rs)
# x = solve(Fs,b)
#
# save("/Users/clarence/Desktop/Summer/Social_resistance/project_imp/complete_project/test/matrix/facts.jld",
#      "factors",Fs)
# Fsl = load("/Users/clarence/Desktop/Summer/Social_resistance/project_imp/complete_project/test/matrix/facts.jld",
#           "factors")
# x2 = solve(Fsl,b)
# println("($(F\b))")
# println("($x)")
# println("($x2)")
