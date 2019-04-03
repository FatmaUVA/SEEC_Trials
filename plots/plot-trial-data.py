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
from scipy import stats

res_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/New-results/" #results/"
#res_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/results/"
plot_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/plots/UVA-Trial/"
Apps = ["ImageView-pics2", "Web360" ,"Skype", "same-video"]
leg = ["2D image viewing", "360-degree images" ,"Skype", "Video"]
t_test = False #change to true if want to perform t-test

plot_name = "all-weeks" #some description to be added to the plot name
rtt = [0]
loss = [0,0.5,3,5,10]
colors = cm.rainbow(np.linspace(0, 5, 20))
colors = ['xkcd:sky blue', 'xkcd:dark lime', 'xkcd:purple','xkcd:orange']
markers = ['^','s','o','*','x','D','+']

#-------------------------- Read Data from FIle ----------------------------------
for app in Apps:
    data_app = "data_"+app
    print(res_dir+"merged-"+app+"-QoE-results-"+plot_name+".txt")
    globals()[data_app] = np.genfromtxt(res_dir+"merged-"+app+"-QoE-results-"+plot_name+".txt", delimiter=' ')
    


#--------------Pre-process the data -----------------------
#seperate by app and packet loss rate. rtt is always 0 so don't worry about it
#also have another array based on app only, each array in the array have all the values for one of the loss values
for app in Apps:
        data_app = "data_"+app
        app_loss_all = app + "_loss_all"
        app_mean = app + "_mean"
        app_std = app + "_std"
        app_error = app + "_error"
        app_all_total_runs = app+"_all_total_runs"
        globals()[app_loss_all] = []
        globals()[app_mean] = []
        globals()[app_std] = []
        globals()[app_error] = []
        globals()[app_all_total_runs] = []

        for l in loss:
            #create array based on app and loss value to hold QoS
            app_loss = app+"_"+str(l)
            globals()[app_loss] = []
            #read rows with specific loss value colunm 2 is loss value
            temp = globals()[data_app][np.where(globals()[data_app][:,2] == l)]
            globals()[app_loss] = temp[:,3] #each app loss will have an array
            print(app,"loss",l,"total runs",len(globals()[app_loss]))
            #globals()[app_loss_total_runs] = len(globals()[app_loss])
            globals()[app_all_total_runs].append(len(globals()[app_loss])) # need total runs for each loss value for CI calculation
            globals()[app_loss_all].append(temp[:,3]) #this array has all arrays with defferent loss values
            globals()[app_mean].append(np.mean(temp[:,3]))
            globals()[app_std].append(np.std(temp[:,3]))

            #total_runs = len(app_loss) #need total run for error computation #FATMA: TODO, this is wrong!!

        print (app," total runs array,",globals()[app_all_total_runs])
        z=1.96 #for 95% CI
        #find error bar: Standared Error (SE) = std/sqrt(n), upper limit = mean + SE*z
        globals()[app_mean] = np.asarray(globals()[app_mean])
        globals()[app_std] = np.asarray(globals()[app_std])
        globals()[app_error] = np.asarray(globals()[app_error])
        globals()[app_all_total_runs] = np.asarray(globals()[app_all_total_runs])
        #compute error bar
        globals()[app_error] = (globals()[app_std]/ np.sqrt(globals()[app_all_total_runs]))
        globals()[app_error] = z*globals()[app_error]
        
        print(app_mean," ",globals()[app_mean])
        print(app_error," ",globals()[app_error])

        if t_test:
            #t-test
            print "for app",app
            app_loss_all = app + "_loss_all"
            #create array to holp all p-values
            p_val_ind = []
            p_val_rel = []
            p_kruskal = []
            for x in range(len(globals()[app_loss_all])): #it was -1
                temp1 = []
                temp2 = []
                temp_kruskal = []
                for y in range(len(globals()[app_loss_all])):
                    a = globals()[app_loss_all][x]
                    b = globals()[app_loss_all][y]
                    #print "t-test ind" ,stats.ttest_ind(a,b)
                    t,p = stats.ttest_ind(a,b)
                    temp1.append(p)
                    s,p = stats.kruskal(a,b)
                    temp_kruskal.append(p)
                    if len(a) > len(b):
                        a=np.random.choice(a,len(b))
                    elif len(a) < len(b):
                        b=np.random.choice(b,len(a))
                    #print "t-test rel" ,stats.ttest_rel(a,b)
                    t,p = stats.ttest_rel(a,b)
                    temp2.append(p)
                p_val_ind.append(temp1)
                p_val_rel.append(temp2)
                p_kruskal.append(temp_kruskal)
            #print loss
            #print p_val_ind
            #print p_val_rel
            #print p_kruskal
            p_val_ind = np.asarray(p_val_ind)
            loss = np.asarray(loss)
            #add loss to col0
            p_val_ind  = np.column_stack((loss,p_val_ind ))
            p_rel  = np.column_stack((loss,p_val_rel ))
            p_kruskal  = np.column_stack((loss,p_kruskal ))
            #add one more col to loss since we added another col 
            loss2 = np.insert(loss, 0, np.nan)
            print "loss 2 ",loss2
            #add loss values to row 0 (make them as header
            p_val_ind = np.insert(p_val_ind, 0,loss2, axis=0)
            p_val_rel = np.insert(p_rel, 0,loss2, axis=0)
            p_kruskal = np.insert(p_kruskal, 0,loss2, axis=0)
            #export to csv files
#            np.savetxt(app+"-t-test.csv", p_val_ind, delimiter=",")
#            np.savetxt(app+"-paired-t-test.csv", p_val_rel, delimiter=",")
#           np.savetxt(app+"-kruskal-test.csv", p_kruskal, delimiter=",")
            #ANOVA test
            print stats.f_oneway(globals()[app_loss_all][0],globals()[app_loss_all][1],globals()[app_loss_all][2],globals()[app_loss_all][3],globals()[app_loss_all][4])
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
    plt.savefig(plot_dir+app+'-clean-boxplot-QoS-vs-loss-'+plot_name+'.png',format="png", bbox_inches='tight')


#------------------------------ MOS line plot ----------------------

col_index = 0 #index to assign differnt colors for lines
plt.figure()
for app in Apps:
    app_mean = app + "_mean"
    if app == "same-video": #because we only have 3 valid points for video
        temp = globals()[app_mean]
        globals()[app_mean] = []
        globals()[app_mean] = [temp[0],temp[1],temp[2]]
        temp = globals()[app_error]
        globals()[app_error] = []
        globals()[app_error] = [temp[0],temp[1],temp[2]]
        temp = loss
        loss = [0,0.5,3]
    plt.plot(loss,globals()[app_mean], color=colors[col_index],linewidth=2.0, marker=markers[col_index],markersize=10,label=app)
    col_index = col_index + 1
    if app == "same-video":
        loss = temp
plt.ylabel('Mean Opinion Score (MOS)',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.18))
#plt.savefig(plot_dir+'clean-mean-QoS-vs-loss-'+plot_name+'.png',format="png", bbox_inches='tight')

# with error bar
col_index = 0 #index to assign differnt colors for lines
plt.figure()
for app in Apps:
    app_mean = app + "_mean"
    app_error = app + "_error"
    if app == "same-video":
        temp = loss
        loss = [0,0.5,3]
    plt.errorbar(loss,globals()[app_mean], color=colors[col_index],linewidth=2.0, marker=markers[col_index],markersize=10,label=app,yerr=globals()[app_error])
    if app == "same-video":
        loss = temp
    col_index = col_index + 1
plt.ylabel('Mean Opinion Score (MOS)',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.18))
plt.savefig(plot_dir+'clean-mean-QoS-vs-loss-with-error-bar-'+plot_name+'.png',format="png", bbox_inches='tight')
'''
#------------------------------ Grouped bar chart ----------------------

#for bar grouped parchart we need the data to be in different format
#based on the loss value each array should have the following: app1_loss0, app2_loss0, app3_loss0
#firt create needed arrays

bar_fill = ['/','*','x','.']
col_index = 0
#fig, ax = plt.subplots()
plt.figure()
N = len(loss) #number of packet loss rate values
ind = np.arange(N)    # the x locations for the groups
width = 0.17         # the width of the bars

for app in Apps:
    app_mean = app + "_mean"
    app_error = app + "_error"
#    globals()[app_mean] = [0,0,0,0,0]
#    globals()[app_error] = [0,0,0,0,0]
    if app == "same-video":
        temp = np.take(globals()[app_mean],(0,1,2))
        temp = np.asarray(temp)
        print "temp ",temp
        globals()[app_mean] = []
        globals()[app_mean] = temp
        globals()[app_error] = np.take(globals()[app_error],(0,1,2))
        ind = np.take(ind,(0,1,2))
        #Apps = ["ImageView-pics2", "Web360" ,"Skype", "same-video"]
#    if app == "Skype": to create gray plots with focus on one app
    plt.bar(ind, globals()[app_mean], width, color=colors[col_index],label=leg[col_index], yerr=globals()[app_error],hatch=bar_fill[col_index])
    plt.plot(ind,globals()[app_mean],color=colors[col_index],linewidth=2,linestyle='--')
    plt.scatter(ind,globals()[app_mean],color='black',marker='o')
#    else:
#        plt.bar(ind, globals()[app_mean], width, color="lightgray",label=leg[col_index], yerr=globals()[app_error],hatch=bar_fill[col_index])
#        plt.plot(ind,globals()[app_mean],color="lightgray",linewidth=2,linestyle='--')
#        plt.scatter(ind,globals()[app_mean],color="lightgray",marker='o')
    col_index = col_index + 1
    ind = [x + width for x in ind]

plt.xticks([r + width for r in range(len(loss))], loss)
plt.ylabel('Mean Opinion Score (MOS)',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.legend(loc='upper left', ncol=4, bbox_to_anchor=(-0.15,1.12))
#change the marker size manually for both lines
#plt.savefig(plot_dir+'patterned-barplot-with-mean-lines-mean-QoS-vs-loss-'+plot_name+'.pdf',format="pdf", bbox_inches='tight')
plt.show()
