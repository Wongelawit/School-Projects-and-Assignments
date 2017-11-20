include("resistance.jl")

function checkSubjectExist(subject,subject_file)
        subject_file = open(subject_file)
        subjects     = readlines(subject_file)
        map(strip, subjects)
        return (subject in subjects)
end

function getGraphIndex(name1,name2,graph_dir)
        graph_file_dir = graph_dir * "/author_graph_table.txt"
        graph_file     = open(graph_file_dir)
        index_list     = []
        for line in eachline(graph_file)
            line            = strip(line);
            elements        = split(line,",,,")
            name            = elements[1]
            index           = parse(elements[2])
            if name1 == name || name2 == name
                push!(index_list,index)
            end
        end

        list_len = size(index_list,1)
        if list_len < 2
            return -2
        end

        if index_list[1] != index_list[2]
            return -1
        end

        return index_list[1]
end

function getAuthorIndex(name1,name2,author_dir)
        author_file     = open(author_dir)
        index_list     = []
        for line in eachline(author_file)
            elements_str    = strip(line)
            elements        = split(elements_str,",,,")
            name            = elements[1]
            index           = parse(elements[2])
            if name1 == name || name2 == name
                push!(index_list,index)
            end
        end
        return index_list
end

function getDimension(graphIndex,edge_dir)
    edge_file_dir = edge_dir * "/edge_set" * string(graphIndex) * "_meta.txt"
    edge_file     = open(edge_file_dir)
    info          = readlines(edge_file)
    info_str      = info[2]
    info_str      = strip(info_str)
    info_ele      = split(info_str,",,,")
    return info_ele
end

function getDistance(name1, name2, subject)
     dir          = pwd()
     dir          = dir * "/data"
     subject_file = dir * "/subjects.txt"

     #step1: go check if the request subject existed in the data set
     if checkSubjectExist(subject,subject_file)
         #get the folder directory
         sub_dir         = dir * "/" * subject
         graph_dir       = sub_dir * "/graph"
         edge_dir        = sub_dir * "/edge"
         matrix_dir      = sub_dir *"/matrix"

         graph_index = getGraphIndex(name1,name2,graph_dir)
         #deal with negative cases
         if graph_index == -1
            println("the distance is infinity")
            return
         end

         if graph_index == -2
            println("author does not exist")
            return
         end

         #get author index in the graph
         graph_index_dir       = graph_dir * "/graph" * string(graph_index) * "_index.txt"
         author_index_list     = getAuthorIndex(name1,name2,graph_index_dir)

         author_index1         = author_index_list[1]
         author_index2         = author_index_list[2]

         #get the matrix dimension information
         dimensions            = getDimension(graph_index,edge_dir)
         num_author            = parse(dimensions[1])
         num_edge              = parse(dimensions[2])

         #load the matrix and compute the distance
         resistance(subject,graph_index,author_index1,author_index2,num_author,num_edge)
    end
end

println(getDistance("Briet Philippe","Cotar Codina","math_physics"))
getDistance("Briet Philippe","Cotar ","math_physics")
getDistance("Briet Philippe","Kwek Leong Chuan","math_physics")
