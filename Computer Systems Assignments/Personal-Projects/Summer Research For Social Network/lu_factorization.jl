Pkg.add("JLD")
using JLD
#number of authors in graph
#num_author = 100785
num_author = 13657
#number of edge in the graph
#num_edge = 407717
num_edge = 27938
#dimension of the M matrix
total_dim = num_edge + num_author + 1

function dist(i,j,F)
  b = zeros(total_dim)
  b[num_edge+1+i] = 1
  b[num_edge+1+j] = -1
  return F\b
end


#directory for the edge set file
edge_file = open("/Users/clarence/desktop/summer/Social_resistance/project_imp/data/math_physics/edge/edge_set1.txt")
#edge_file = open("/Users/clarence/Desktop/Summer/Social_resistance/project_imp/complete_project/test/edge/edge_set1/")

V = spzeros(num_author,num_edge)

edge_index = 1
for line in eachline(edge_file)
  edge = strip(line)
  elements = split(edge,",,,")

  edge_node1 = parse(elements[1])
  edge_node2 = parse(elements[2])
  edge_value = parse(elements[3])
  edge_value = sqrt(edge_value)

  V[edge_node1,edge_index] += edge_value
  V[edge_node2,edge_index] -= edge_value
  edge_index = edge_index + 1
end

close(edge_file)

#cosntruct M matrix
M = spzeros(total_dim, total_dim)

#-I
M[1:num_edge,1:num_edge] = -eye(num_edge,num_edge)
#-1
M[num_edge+1,num_edge+1] = -1
#e
M[num_edge+2:total_dim,num_edge+1] = ones(num_author,1)
#e^T
M[num_edge+1,num_edge+2:total_dim] = ones(1,num_author)
#V
M[num_edge+2:total_dim,1:num_edge] = V
#V^T
M[1:num_edge,num_edge+2:total_dim] = transpose(V)

#save("/Users/clarence/desktop/summer/Social_resistance/project_imp/data/math_physics/edge/data.jld", "data", M)

#X = load("/Users/clarence/desktop/summer/Social_resistance/project_imp/data/math_physics/edge/data.jld")["data"]
F = lufact(M)
@time x = dist(1,2,F)
