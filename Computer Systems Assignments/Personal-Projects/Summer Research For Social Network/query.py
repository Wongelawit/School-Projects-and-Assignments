import os
import julia

j = julia.Julia()

class query(object):
    
    def __init__(self):
        self.dir          = os.path.dirname(os.path.realpath(__file__)) + "/data"
        self.subject_file = self.dir + "/subjects.txt"
    
    ####################################################
    def getDistance(self,name1, name2, subject):
        #step1: go check if the request subject existed in the data set
        if self.checkSubjectExist(subject):
            #get the folder directory
            sub_dir         = self.dir + "/" + subject
            graph_dir       = sub_dir + "/graph"
            edge_dir        = sub_dir + "/edge"
            matrix_rid      = sub_dir +"/matrix"
        
            graph_index = self.getGraphIndex(name1,name2,graph_dir)
            #deal with negative cases
            
            #get author index in the graph
            graph_index_dir       = graph_dir + "/graph" + str(graph_index) + "_index.txt"
            author_index_list     = self.getAuthorIndex(name1,name2,graph_index_dir)
        
            author_index1         = author_index_list[0]
            author_index2         = author_index_list[1]
        
            #load the matrix and compute the distance
            #(subject,matrix_index,author_index1,author_index2,num_edge,num_author)
            #need to get number of edge and author later
            j.run("using resistance")
            j.run("resistance.resistance("+subject      +","
                                          +graph_index  +","
                                          +author_index1+","
                                          +author_index2+","
                                          +str(13657)   +","
                                          +str(21446)   +")")
        
        else:
            print "hello world"

    ####################################################
    def checkSubjectExist(self, subject):
        subject_file = open(self.subject_file)
        subjects     = subject_file.readlines()
        map(str.rstrip, subjects)
        subjects     = set(subjects)
        return (subject in subjects)
    
    ####################################################
    def getGraphIndex(self,name1,name2,graph_dir):
        graph_file_dir = graph_dir + "/author_graph_table.txt"
        graph_file     = open(graph_file_dir)
        index_list     = []
        for line in enumerate(graph_file):
            line            = str(line[1]);
            elements        = line.strip().split(",,,")
            name            = elements[0]
            index           = int(elements[1])
            if name1 == name or name2 == name:
                index_list.append(index)


        if len(index_list) < 2:
            return -2

        if(index_list[0] != index_list[1]):
            return -1

        return index_list[0]

    ####################################################
    def getAuthorIndex(self,name1,name2,author_dir):
        author_file     = open(author_dir)
        index_list     = []
        for line in enumerate(author_file):
            line            = str(line[1]);
            elements        = line.strip().split(",,,")
            name            = elements[0]
            index           = int(elements[1])
            if name1 == name or name2 == name:
                index_list.append(index)

        return index_list






