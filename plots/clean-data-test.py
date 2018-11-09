
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()
import plotly as py
import plotly.graph_objs as go
import plotly.figure_factory as ff
import sys

res_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/results/"
plot_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/plots/"
plot_name = "clean-video-qoe"
data_file = "merged-video-QoE-results.txt"

rtt = [0,50,150]
loss = [0,0.05,1]

data = np.genfromtxt(res_dir+data_file, delimiter=' ') #, usecols=(0,),unpack=True) loadtxt

#============== clean up data ================
#remove data points where participant gave the same ratign for all conditions

x = []
temp = []
count = 0

x.append(data[0]) #add the first data with index i
for i in range(len(data)):
    if i+1 < len(data):
        if int(data[i][0]) == int(data[i+1][0]):
            print "equal indeces ",int(data[i][0]) ," ", int(data[i+1][0])
            x.append(data[i+1])
        else:
            for j in range(len(x)):
                #print "x = ",x
                print "inside 2nd loop index is ",x[j][0] 
                if j+1 < len(x):
                    if int(x[j][3]) != int(x[j+1][3]):
                        print "index x[j][0] and x[j+1][0]",x[j][0]," ", x[j+1][0], "int(x[j][3]) != int(x[j+1][3])", int(x[j][3]) ," ", int(x[j+1][3])
                        print "index is ", x[j][0]
                        temp.append(x)
                        count = count +1
                        #x = [] # reinitialize
                        #x.append(data[i+1]) #add the first distinct index
                        break
            x = [] # reinitialize
            x.append(data[i+1]) #add the first distinct index

print "total added points", count
data  = np.concatenate( temp, axis=0 ) #change it to numpy array with proper format

print "data ", data
np.savetxt('data-array.out', data, delimiter=',')
