# This code combines the employee info from two csv files and return the tweeked data
# MMB-021919
import datetime
from datetime import datetime
import csv
from collections import Counter

us_state_abbrev = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
}

with open('employee_data.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    EID = []
    FLname=[]
    DOB = []
    SSN=[]
    State=[]

    for row in readCSV:
        EID.append(row[0])
        FLname.append(row[1])
        DOB.append(row[2])
        SSN.append(row[3])
        State.append(row[4])

    #remove the headers    
    EID.pop(0)
    FLname.pop(0)
    DOB.pop(0)
    SSN.pop(0)
    State.pop(0)

    #splitting FLname into first and last name lists
    First_name=[i.split(' ', 1)[0] for i in FLname]
    Last_name =[i.split(' ', 1)[1] for i in FLname]
    
    #chaning DOB format
    DATE=list(datetime.strptime(date,'%Y-%m-%d') for date in DOB)
    DOB_conv=[DATE[i].strftime('%m/%d/%Y') for i in range(len(DATE))]

    #changing SSN format
    SSN_conv=['***-**-'+str(SSN[i][7:11]) for i in range(len(SSN))]

    #Changing state fromat using dictionary
    State_conv=[us_state_abbrev[State[i]] for i in range(len(State))]

    #wrting the results back to a text file
    file = open('results_employee.txt','w+') 
    file.write('Employee datasheet\nEmp ID, First Name , Last Name , DOB ,   SSN   ,   State\n')
    for i in range(len(DOB)):
        file.write("{}, {}, {}, {}, {}, {}\n" .format(EID[i], First_name[i], Last_name[i], DOB_conv[i], SSN_conv[i], State_conv[i]))
    file.close()