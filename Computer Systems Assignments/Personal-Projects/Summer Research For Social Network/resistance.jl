Pkg.add("JLD")
using JLD
include("toMmatrix.jl")

function solve(F::LUfactors, b)
    L, U, p, q, Rs = F.L, F.U, F.p, F.q, F.Rs
    x = U \ ( L \ ((Rs.*b)[p,]) )
    ipermute!(x,q)
    return norm(x,2)
end

function resistance(subject,matrix_index,author_index1,author_index2,num_edge,num_author)

  cur_dir     = pwd()
  matrix_dir  = cur_dir*"/data/"*subject*"/matrix/matrix"*string(matrix_index)*"_factors.jld"
  Fs          = load(matrix_dir,"matrix")
  println(size(Fs.U))
  total_dim   = num_edge + num_author +1

  b = zeros(total_dim)
  b[num_edge+1+author_index1] = 1
  b[num_edge+1+author_index2] = -1

  return solve(Fs,b)
end
