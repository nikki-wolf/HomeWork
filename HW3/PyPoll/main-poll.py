# PyPoll poll Analysis, 
# MMB -021919
import csv
from collections import Counter
with open('election_data.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    id = []
    corr_dates=[]
    county = []
    cand=[]

    for row in readCSV:
        id.append(row[0])
        county.append(row[1])
        cand.append(row[2])

    #remove the headers    
    id.pop(0)
    county.pop(0)
    cand.pop(0)

    print("Total Votes: ", len(id))

    # counting each candidate votes
    count_cand=Counter(cand)
    print(count_cand)
    for key,value in count_cand.items():
        print ("{}: {:.3%}  ({})" .format(key,value/len(id),value))

    print("-----------------------------------")
    print("Winner: {}" .format(list(count_cand.keys())[list(count_cand.values()).index(max(count_cand.values()))]))

        #writing the results to a text file
    file = open('results_PyPoll.txt','w+') 
    file.write('Election Results\n--------------------------------\n')
    file.write('Total Votes: %i\n' % len(id))
    file.write('--------------------------------\n')
    for key,value in count_cand.items():
        file.write ('{}: {:.3%}  ({})\n' .format(key,value/len(id),value))
    file.write('\n--------------------------------\n')
    file.write("\nWinner: {}\n" .format(list(count_cand.keys())[list(count_cand.values()).index(max(count_cand.values()))])) 
    file.write('--------------------------------\n')    
    file.close()
