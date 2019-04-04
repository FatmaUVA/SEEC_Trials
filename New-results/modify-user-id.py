#This script change the user id in the merged results file
#The user id is not sequential, because each station starts with 1
#The result file has four columns   0: user_id 
#                                   1: all 0's column, ignore
#                                   2: loss
#                                   3: QoE

import numpy as np

res_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/New-results/"

Apps = ["ImageView-pics2", "Web360" ,"Skype", "same-video"]

for app in Apps:
    print app
    data = np.genfromtxt(res_dir+"merged-"+app+"-QoE-results-all-weeks.txt", delimiter=' ')
    user_id,loss,qoe = np.loadtxt(res_dir+"merged-"+app+"-QoE-results-all-weeks.txt", delimiter=' ',usecols=(0,2,3),unpack=True) 
    
    new_index = 1
    user_id_arr = []
    data[0,1] = 1 #initialize first user id to 1
    count = 0
    print "length of array is, ",len(data[:,0])
    for i in range(1,len(data[:,0])):
        count+=1
        if data[i,0]==data[i-1,0] and count <3:
            data[i,1] = new_index
        else:
            if count <3:
                print "less than 3 QoS", data[i,0]," index is ", i
            count = 0
            new_index+=1
            data[i,1] = new_index

    #print data[:,(1,2,3)]

    #export to csv file
    np.savetxt(res_dir+app+"-QoE-results-mod-index-all-weeks.csv",data[:,(1,2,3)], delimiter=',')
