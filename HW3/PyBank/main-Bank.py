# PyBank financial Analysis, 
# MMB -021919
import csv
#import datetime
#import datetime as DT
#from datetime import datetime
#read from the budget_data file and generate two lists: dates and PLs(profit/loss)
with open('budget_data.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    dates = []
    corr_dates=[]
    PLs = []

    for row in readCSV:
        dates.append(row[0])
        PLs.append(row[1])

    #remove the headers    
    dates.pop(0)
    PLs.pop(0)

    #convert all the Profit/loss string elements into a list of integer values
    PLs=list(map(int,PLs))
    print("Total Months: ", len(PLs))

    #sum of profit/loss
    Tot_PL=sum(PLs)
    print("Total Profit/Loss: $ ",Tot_PL)

    # finding the change in Profit/Loss
    b=PLs.copy()
    b.pop(0) # pop out the first element
    b.append(0) # add zero to the end of the generated array
    c=list(map(lambda x,y: y-x, PLs,b))

    #finding the average change in profit/loss   
    c.pop()
    avg=sum(c)/len(c)
    print("Average change in Profit/Loss= $",avg)

    #finding the max in change and index it
    print("Greatest Increase in Profits: {0} $ ({1})" .format(dates[c.index(max(c))+1], max(c)))
    print("Greatest Decrease in Profits: {0} $ ({1})" .format(dates[c.index(min(c))+1], min(c)))

    #writing the results to a text file
    file = open('results_PyBAnk.txt','w+') 
    file.write('Financial Analysis\n--------------------------------\n')
    file.write('Total Months: %i\n' % len(PLs))
    file.write('Total Profit/Loss: $ %d\n' %Tot_PL)
    file.write('Average change in Profit/Loss= $%.2f\n' % avg)
    file.write('Greatest Increase in Profits: {0} $ ({1})\n' .format(dates[c.index(max(c))+1], max(c)))
    file.write('Greatest Increase in Profits: {0} $ ({1})\n' .format(dates[c.index(min(c))+1], min(c)))
    file.close()

        