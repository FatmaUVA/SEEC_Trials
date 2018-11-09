##############################################################################################################
#   Fatma Alali
#   This code read data files whihc has the following format: index rtt loss QoS
#   This code generate multiple plots:  
#                   boxplots for each activity
#                   lines plot where x-axis loss rate, y-axis Mean QoE (MOS), many lines each for an activity. 
#                   Bar plots each group is a packet loss value, in each group one bar for each activity (MOS)
###############################################################################################################


import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import sys
import math

res_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/results/"
plot_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/plots/UVA-Trial/"
Apps = ["ImageView-pics1", "ImageView-pics2", "Insta360", "Skype"]

rtt = [0]
loss = [0,3,5]

#-------------------------- Read Data from FIle ----------------------------------
for app in Apps:
    data_app = "data_"+app
    globals()[data_app] = np.genfromtxt(res_dir+"merged-"+app+"-QoE-results-uva-1.txt", delimiter=' ')
    


#--------------Pre-process the data -----------------------
#seperate by app and packet loss rate. rtt is always 0 so don't worry about it
#also have another array based on app only, each array in the array have all the values for one of the loss values
for app in Apps:
        data_app = "data_"+app
        app_loss_all = app + "_loss_all"
        app_mean = app + "_mean"
        app_std = app + "_std"
        app_error = app + "_error"
        globals()[app_loss_all] = []
        globals()[app_mean] = []
        globals()[app_std] = []
        globals()[app_error] = []

        for l in loss:
            #create array based on app and loss value to hold QoS
            app_loss = app+"_"+str(l)
            globals()[app_loss] = []
            #read rows with specific loss value colunm 2 is loss value
            temp = globals()[data_app][np.where(globals()[data_app][:,2] == l)]
            globals()[app_loss] = temp[:,3] #each app loss will have an array
            globals()[app_loss_all].append(temp[:,3]) #this array has all arrays with defferent loss values
            globals()[app_mean].append(np.mean(temp[:,3]))
            globals()[app_std].append(np.std(temp[:,3]))

            total_runs = len(app_loss) #need total run for error computation
    
        z=1.96 #for 95% CI
        #find error bar: Standared Error (SE) = std/sqrt(n), upper limit = mean + SE*z
        globals()[app_mean] = np.asarray(globals()[app_mean])
        globals()[app_std] = np.asarray(globals()[app_std])
        globals()[app_error] = np.asarray(globals()[app_error])
        #compute error bar
        globals()[app_error] = (globals()[app_std]/ math.sqrt(total_runs))
        globals()[app_error] = z*globals()[app_error]
        
        print(app_mean," ",globals()[app_mean])
        print(app_error," ",globals()[app_error])

'''
#------------------------------ box plot --------------------------------------

for app in Apps:
    app_loss_all = app + "_loss_all"
    plt.figure()
    plt.boxplot(globals()[app_loss_all])
    plt.ylim((0,6))
    plt.ylabel('Quality of Experience',fontsize=14)
    plt.xlabel('Packet loss rate (%)',fontsize=14)
    plt.xticks([1, 2, 3], loss)
    plt.title(app+" QoS")
    plt.savefig(plot_dir+app+'-boxplot-QoS-vs-loss.png',format="png", bbox_inches='tight')
'''
#------------------------------ MOS line plot ----------------------

colors = cm.rainbow(np.linspace(0, 7, 20))
markers = ['^','s','o','*','x','D','+']

col_index = 0 #index to assign differnt colors for lines
plt.figure()
for app in Apps:
    app_mean = app + "_mean"
    plt.plot(loss,globals()[app_mean], color=colors[col_index],linewidth=2.0, marker=markers[col_index],markersize=10,label=app)
    col_index = col_index + 1
plt.ylabel('Mean Opinion Score (MOS)',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.18))
plt.savefig(plot_dir+'mean-QoS-vs-loss.png',format="png", bbox_inches='tight')

# with error bar
colors = cm.rainbow(np.linspace(0, 7, 20))
markers = ['^','s','o','*','x','D','+']
col_index = 0 #index to assign differnt colors for lines
plt.figure()
for app in Apps:
    app_mean = app + "_mean"
    app_error = app + "_error"
    plt.errorbar(loss,globals()[app_mean], color=colors[col_index],linewidth=2.0, marker=markers[col_index],markersize=10,label=app,yerr=globals()[app_error])
    col_index = col_index + 1
plt.ylabel('Mean Opinion Score (MOS)',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.18))
plt.savefig(plot_dir+'mean-QoS-vs-loss-with-error-bar.png',format="png", bbox_inches='tight')

#------------------------------ Grouped bar chart ----------------------

#for bar grouped parchart we need the data to be in different format
#based on the loss value each array should have the following: app1_loss0, app2_loss0, app3_loss0
#firt create needed arrays

colors = cm.rainbow(np.linspace(0, 7, 20))
col_index = 0
#fig, ax = plt.subplots()
plt.figure()
N = len(loss) #number of packet loss rate values
ind = np.arange(N)    # the x locations for the groups
print("ind ",ind)
width = 0.17         # the width of the bars
for app in Apps:
    app_mean = app + "_mean"
    app_error = app + "_error"
    plt.bar(ind, globals()[app_mean], width, color=colors[col_index],label=app, yerr=globals()[app_error])
    col_index = col_index + 1
    ind = [x + width for x in ind]

plt.xticks([r + width for r in range(len(loss))], loss)
plt.ylabel('Mean Opinion Score (MOS)',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.18))
plt.savefig(plot_dir+'barplot-mean-QoS-vs-loss.png',format="png", bbox_inches='tight')
