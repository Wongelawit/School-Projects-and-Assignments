Pkg.add("JLD")
using JLD

type LUfactors
    L ::SparseMatrixCSC{Float64,Int64}
    U ::SparseMatrixCSC{Float64,Int64}
    p ::Array{Int64,1}
    q ::Array{Int64,1}
    Rs::Array{Float64,1}
end

function M_matrix(subject,graphIndex)
  cur_dir = pwd()
  meta_dir  = cur_dir * "/data/"*subject*"/edge/edge_set" * string(graphIndex) * "_meta.txt"
  meta_file = open(meta_dir)

  meta_info     = readlines(meta_file)
  meta_info_str = meta_info[2]
  meta_info_str = strip(meta_info_str)
  meta_info_ele = split(meta_info_str,",,,")
  #number of authors in graph
  num_author = parse(meta_info_ele[1])
  #number of edge in the graph
  num_edge   = parse(meta_info_ele[2])
  #dimension of the M matrix
  total_dim = num_edge + num_author + 1

  #directory for the edge set file
  edge_dir  = cur_dir * "/data/"*subject*"/edge/edge_set" * string(graphIndex) * ".txt"
  edge_file = open(edge_dir)

  #create a vector I and J and then construct the sparse matrix from there
  # V = spzeros(num_author,num_edge)
  N1 = Array(Int64, num_edge*2)
  N2 = Array(Int64, num_edge*2)
  W  = Array(Float64, num_edge*2)

  edge_index = 1
  coord_index = 1
  for line in eachline(edge_file)
    edge = strip(line)
    elements = split(edge,",,,")

    edge_node1 = parse(elements[1])
    edge_node2 = parse(elements[2])
    edge_value = parse(elements[3])
    edge_value = sqrt(edge_value)
    #
    # V[edge_node1,edge_index] += edge_value
    # V[edge_node2,edge_index] -= edge_value
    N1[coord_index] = edge_node1
    N2[coord_index] = edge_index
    W[coord_index]  += edge_value

    coord_index = coord_index + 1

    N1[coord_index] = edge_node2
    N2[coord_index] = edge_index
    W[coord_index] -= edge_value

    coord_index = coord_index + 1
    edge_index = edge_index + 1
  end
  close(edge_file)

  V = sparse(N1,N2,W,num_author,num_edge)

  #cosntruct M matrix
  M = spzeros(total_dim, total_dim)
  en = ones(num_author)
  M = [
      -speye(num_edge,num_edge)  spzeros(num_edge,1)   V'
      spzeros(1,num_edge)         -1                   en'
      V                           en                   spzeros(num_author,num_author)
      ]

  F = lufact(M)
  L, U, p, q, Rs = F[:(:)]
  Fs = LUfactors(L,U,p,q,Rs)

  outDir = cur_dir*"/data/"*subject*"/matrix/matrix"*string(graphIndex)*"_factors.jld"
  tag    = "matrix"
  save(outDir, "matrix", Fs)
end
