import time
import urllib2
import datetime
from itertools import ifilter
from collections import Counter, defaultdict
import xml.etree.ElementTree as ET

from bs4 import BeautifulSoup
import matplotlib.pylab as plt
import pandas as pd
import numpy as np
import bibtexparser

class dataHavestor():
    
    def __init__(self, dir, subject, begin_year, end_year):
        #user input
        self.dir            = dir
        self.subject        = subject
        self.begin_year     = begin_year
        self.end_year       = end_year
        #construct local variable from user input
        self.data_file_dir           = str(dir) + "/" + str(subject) + "_data.txt"
        self.data_meta_file_dir      = str(dir) + "/" + str(subject) + "_data_meta.txt"


    def harvest(self):
        
        #base url for harvesting
        OAI = "{http://www.openarchives.org/OAI/2.0/}"
        ARXIV = "{http://arxiv.org/OAI/arXiv/}"
        base_url = "http://export.arxiv.org/oai2?verb=ListRecords&"
        
        counter = 0
        output_file         = open(self.data_file_dir,"a+")
        output_meata_file   = open(self.data_meta_file_dir,"a+")

        url = (base_url                          +
               "from="                           +
               self.begin_year                   +
               "-01-01&until="                   +
               self.end_year                     +
               "-12-31&"                         +
               "metadataPrefix=arXiv&set="       +
               self.subject)
           
        while True:
            print "fetching", url
            try:
                response = urllib2.urlopen(url)
            except urllib2.HTTPError, e:
                if e.code == 503:
                    to = int(e.hdrs.get("retry-after", 30))
                    print "Got 503. Retrying after {0:d} seconds.".format(to)
                    time.sleep(to)
                    continue
                else:
                    raise

            xml = response.read()
            root = ET.fromstring(xml)
            for record in root.find(OAI+'ListRecords').findall(OAI+"record"):
                #list to store the elements we want from the record:
                #title
                #author
                entry = []
                arxiv_id = record.find(OAI+'header').find(OAI+'identifier')
                meta = record.find(OAI+'metadata')
                info = meta.find(ARXIV+"arXiv")
                #get the paper title
                title = info.find(ARXIV+"title").text
                entry.append(title)
                #get the author names
                authors = info.find(ARXIV+"authors").findall(ARXIV+"author")
                for author in authors:
                    lastname = ""
                    firstname = ""
                    #check if first name or last name entries is null(this could be the case sometimes)
                    if author.find(ARXIV+"keyname") is not None:
                        lastname = author.find(ARXIV+"keyname").text

                    if author.find(ARXIV+"forenames") is not None:
                        firstname= author.find(ARXIV+"forenames").text

                    name = lastname + " " + firstname
                    entry.append(name)
        
                entry_str = ",,,".join(entry).encode('utf-8').replace('\n', ' ').replace('\r', '') + "\n"
                output_file.write(entry_str)
                counter += 1
                
            #The list of articles returned by the API comes in chunks of
            #1000 articles. The presence of a resumptionToken tells us that
            #there is more to be fetched.
            token = root.find(OAI+'ListRecords').find(OAI+"resumptionToken")
            if token is None or token.text is None:
                break
            else:
                url = base_url + "resumptionToken=%s"%(token.text)
    
        meta = ("cs article from " +
                str(self.begin_year)   +
                " to "                 +
                str(self.end_year)     +
                " with "               +
                str(counter)           +
                " papers" + "\n")
        output_meata_file.write(meta)
        output_file.close()
        output_meata_file.close()

def main():
    df = dataHavestor("/Users/clarence/desktop/summer/Social_resistance/project_imp/complete_project","cs","2015","2017")
    df.harvest()

if __name__ == "__main__":
    main()
