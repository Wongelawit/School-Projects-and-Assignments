import glob
import os
import statistics
import time
import networkx as nx

class dataParser(object):
    ########################################################################################
    def __init__(self):
        self.data_dir = os.path.dirname(os.path.realpath(__file__)) + "/data"
        self.out_dir  = self.data_dir

    ########################################################################################
    def disjointComponent(self,in_file,out_dir):
        #get the paper list from the paper entries file
        input_file = open(in_file)

        paper_sets = []

        #parse the paper list entries into a list of set that contain author information
        for line in enumerate(input_file):
            line            = str(line[1]);
            elements        = line.strip().split(",,,")
            #filter out empty string
            elements        = list(filter(None, elements))
            num_paper_ele   = len(elements)
            author_ele      = set(elements[1:num_paper_ele])
            #strip the white space at the end of the string
            map(str.rstrip, author_ele)
            paper_sets.append(author_ele)


        #now obtain a complete set of authors of paper
        #{
        #[author1, 2,...]
        #[1,2,...]
        #...
        #}

        G_sets = nx.Graph()
        for author_set in paper_sets:
            l = list(author_set)
            G_sets.add_edges_from(zip(l, l[1:]))

        graph_author_list = list(nx.connected_components(G_sets))

        graph_num = 1
        graph_info = []
        graph_edge_info = []
        #now iterate through the paper set list again to divide the paper entries
        for graph in graph_author_list:
            
            author_index = 1
            output_author_graph_dir = str(out_dir+"/author_graph_table.txt")
            output_author_graph_file = open(output_author_graph_dir,"a+")
            
            output_author_graph_ind_dir  = out_dir + "/graph" + str(graph_num) + "_index.txt"
            output_author_graph_ind_file = open(output_author_graph_ind_dir,"a+")
            
            for author in graph:
                new_author = author.rstrip() + ",,," + str(graph_num) + "\n"
                new_index  = author.rstrip() + ",,," + str(author_index) + "\n"
                output_author_graph_file.write(new_author)
                output_author_graph_ind_file.write(new_index)
                author_index = author_index+1

            output_author_graph_file.close()
            output_graph_file_dir = out_dir + "/graph" + str(graph_num) + ".txt"
            output_graph_file = open(output_graph_file_dir,"a+")

            edge_num = 0
            for item in paper_sets:
                if len(graph.intersection(item))!=0:
                    #strip the white space at the end of string
                    map(str.rstrip, item)
                    output_str = ",,,".join(item) + "\n"
                    output_graph_file.write(output_str)
                    edge_num += 1

            output_graph_meta_dir  = out_dir + "/graph" + str(graph_num) + "_meta.txt"
            output_graph_meta_file = open(output_graph_meta_dir,"a+")
            head_str               = "#graph number,,,author number,,,paper number \n"
            meta_str               = (str(graph_num)+",,,"+str(author_index-1)+",,,"+str(edge_num) + "\n")
            graph_info.append(author_index-1)
            graph_edge_info.append(edge_num)
            output_graph_meta_file.write(head_str)
            output_graph_meta_file.write(meta_str)
            
            output_graph_file.close()
            graph_num = graph_num + 1
                
        median              = statistics.median(graph_info)
        mean                = statistics.mean(graph_info)
        std                 = statistics.stdev(graph_info)
        largest             = max(graph_info)
        largest_graph_index = graph_info.index(largest) + 1
        total_graph         = len(graph_info)
        total_author        = sum(graph_info)

        output_stat_dir  = str(out_dir+"/stat.txt")
        output_stat_file = open(output_stat_dir, "a+")

        header_str              = "#total number of graph, total number of author, largest graph size, largest graph index \n"
        info_str                = (str(total_graph)+",,,"+str(total_author)+",,,"+str(largest)+",,,"+str(largest_graph_index)+"\n")

        output_stat_file.write(header_str)
        output_stat_file.write(info_str)

        output_stat_file.close()
    
    ########################################################################################
    #function that turns a paper file into data structure for computation
    def paperToGraph(self,inDir, graphIndex,outDir):
        #get the author list from the author index file
        input_author_dir    = str(inDir + "/graph" + str(graphIndex) + "_index.txt")
        input_author_file   = open(input_author_dir)

        author_list = []
        num_author = 0  #current number of author in the network

        #extract current author information from the input file
        for line in enumerate(input_author_file):
            author_line = str(line[1])
            author_line = author_line.strip()
            author_element = author_line.split(",,,")
            author_list.append(author_element[0].rstrip())

        num_author = len(author_list)
        input_author_file.close()

        #get the paper author data
        input_paper_dir = str(inDir + "/graph" + str(graphIndex) + ".txt")
        input_paper_file = open(input_paper_dir)
        
        edge_set = dict()
        for line in enumerate(input_paper_file):
            line            = str(line[1]);
            author_ele      = line.strip().split(",,,")
            #strip the white space at the end of the string
            map(str.rstrip, author_ele)
            num_paper_ele   = len(author_ele)
            if num_paper_ele == 1:
                continue

            edge_val          = float(1)/float(num_paper_ele-1)
            author_index_list = []

            #get the author index from existing file or assign a new unique index if
            #it does not exist previously
            for author_i in range(0,num_paper_ele):
                if author_ele[author_i].rstrip() in author_list:
                    author_index_list.append(author_list.index(author_ele[author_i].rstrip()) + 1)
                else:
                        print "adding new author"
                        author_index_list.append(num_author + 1)
                        #add new author to the author index file
                        output_author_dir = str(inDir + "graph" + str(graphIndex) + "_index.txt")
                        output_author_file = open(output_author_dir,"a")
                        new_author = author_ele[author_i] + ",,," + str(num_author + 1) + "\n"
                        output_author_file.write(new_author)
                        output_author_file.close()
                        num_author += 1
                        author_list.append(author_ele[author_i])

            #create edge entries
            for author1_i in range(0,num_paper_ele-1):
                for author2_i in range(author1_i,num_paper_ele):
                    if author1_i != author2_i:
                        node1           = int(author_index_list[author1_i])
                        node2           = int(author_index_list[author2_i])
                        edge_weight     = float(edge_val)
                        #format of the key in dict:
                        #node1,,,node2
                        #with invariance: node1 < node2
                        if node1 < node2:
                            key = str(node1) + ",,," + str(node2)
                            if key in edge_set:
                                    edge_set[key]+=edge_weight
                            else:
                                edge_set.update({key:edge_weight})
                        else:
                            key = str(node2) + ",,," + str(node1)
                            if key in edge_set:
                                    edge_set[key]+=edge_weight
                            else:
                                edge_set.update({key:edge_weight})
        
        output_edge_dir     = str(outDir + "/edge_set"+ str(graphIndex) + ".txt")
        output_edge_file    = open(output_edge_dir, "a+")

        for key, value in edge_set.items():
            edge_str = key + ",,," + str(value) + "\n"
            output_edge_file.write(edge_str)

        output_edge_file.close()

        output_edge_meta_dir  = str(outDir + "/edge_set"+ str(graphIndex) + "_meta.txt")
        output_edge_meta_file = open(output_edge_meta_dir, "a+")

        meta_header     = "#number of author,,,number of edge\n"
        meta_str        = str(num_author) + ",,," + str(len(edge_set)) +"\n"
        output_edge_meta_file.write(meta_header)
        output_edge_meta_file.write(meta_str)
        output_edge_meta_file.close()
    
    ########################################################################################
    def getDataRepo(self):

        repo_list_file_dir = self.data_dir + "/subjects.txt"
        repo_list_file     = open(repo_list_file_dir)
        repo_list          = []
        
        #get the list of data repo
        for line in enumerate(repo_list_file):
            line           = str(line[1])
            subject        = line.strip()
            subject_dir    = self.data_dir + "/" + subject
            repo_list.append(subject_dir)
        
        #set up the repo directory structure
        for repo in repo_list:
            graph_dir   = repo + "/graph"
            edge_dir    = repo + "/edge"
            matrix_dir  = repo + "/matrix"
            
            if not os.path.exists(graph_dir):
                os.makedirs(graph_dir)
            
            if not os.path.exists(edge_dir):
                os.makedirs(edge_dir)

            if not os.path.exists(matrix_dir):
                os.makedirs(matrix_dir)

        #find the connected component on each repo
        for repo in repo_list:
            data_dir = repo + "/raw/data.txt"
            out_dir  = repo + "/graph"
            self.disjointComponent(data_dir,out_dir)
        
        #parse the connected graph data file into edge file
        for repo in repo_list:
                self.iterativePaperToGraph(repo)

    ########################################################################################
    def iterativePaperToGraph(self,repo):
        graph_in_dir    = repo + "/graph"
        outDir          = repo + "/edge"
        stat_dir        = graph_in_dir + "/stat.txt"
        stat_file       = open(stat_dir)
        info            = stat_file.readlines()
        info_str        = info[1]
        info_ele        = info_str.strip().split(",,,")

        num_graph   = int(info_ele[0])
        for graphIndex in range(1,num_graph+1):
            self.paperToGraph(graph_in_dir,graphIndex,outDir)



