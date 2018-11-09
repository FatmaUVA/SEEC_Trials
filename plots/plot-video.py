#pip install --upgrade --ignore-installed --install-option '--install-data=/usr/local' seaborn

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()
import plotly as py
import plotly.graph_objs as go
import plotly.figure_factory as ff
import sys

res_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/results/"
plot_dir = "/Users/fatmaalali/Documents/UVA/Scripts/SEEC_Trials/plots/"
plot_name = "video-qoe"
data_file = "merged-video-QoE-results.txt"

rtt = [0,50,150]
loss = [0,0.05,1]

data = np.genfromtxt(res_dir+data_file, delimiter=' ') #, usecols=(0,),unpack=True) loadtxt

'''
#============== clean up data ================
#remove data points where participant gave the same ratign for all conditions

x = []
temp = []
count = 0

x.append(data[0]) #add the first data with index i
for i in range(len(data)):
    if i+1 < len(data):
        if int(data[i][0]) == int(data[i+1][0]):
            x.append(data[i+1])
        else:
            for j in range(len(x)):
                if j+1 < len(x):
                    if int(x[j][3]) != int(x[j+1][3]):
                        temp.append(x)
                        count = count +1
                        break
            x = [] # reinitialize
            x.append(data[i+1]) #add the first distinct index

print "total added points", count
data  = np.concatenate( temp, axis=0 ) #change it to numpy array with proper format

#print "data ", data
#np.savetxt('data-array.out', data, delimiter=',')
'''
# =================== plot RTT, loss independently ========================
qoe_rtt = []
qoe_loss = []

for r in rtt:
    #read all data where loss is zero
    temp = data[np.where(data[:,2] == 0)] #np.where(data[:,[2]] == 0)
    temp = temp[np.where(temp[:,1] == r)] #read rows with specific rtt value
#    if rtt == 0: # to use only one vlaue of the 2 0 0 recorded values
#        answer = (a[a%2==1])
#        temp = (temp[temp%2==1])
    qoe_rtt.append(temp[:,3]) #read qoe values for the specific rtt value


for l in loss:
    #read all data where rtt is zero
    temp = data[np.where(data[:,1] == 0)] 
    temp = temp[np.where(temp[:,2] == l)] #read rows with specific rtt value
    qoe_loss.append(temp[:,3]) #read qoe values for the specific rtt value
    print(qoe_loss)

plt.figure()
plt.boxplot(qoe_rtt)
plt.ylim((0,6))
plt.ylabel('Video quality',fontsize=14)
plt.xlabel('RTT (ms)',fontsize=14)
plt.xticks([1, 2, 3],rtt)
plt.savefig(plot_dir+plot_name+'-rtt-only.png',format="png", bbox_inches='tight')

plt.figure()
plt.boxplot(qoe_loss)
plt.ylim((0,6))
plt.ylabel('Video quality',fontsize=14)
plt.xlabel('Packet loss rate (%)',fontsize=14)
plt.xticks([1, 2, 3], loss)
plt.savefig(plot_dir+plot_name+'-loss-only.png',format="png", bbox_inches='tight')

# =================== plot RTT, loss combined =======================

qoe_combined = []
x_values = ['50, 0.05','50, 1','150, 0.05','150, 1'] #I did it manulay because python cannot convert float to string easily to use it for x tick labels
for r in [50,150]:
    for l in [0.05,1]:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        qoe_combined.append(temp[:,3])
        #print temp

plt.figure()
plt.boxplot(qoe_combined)
plt.ylim((0,6))
plt.ylabel('Video quality',fontsize=14)
plt.xlabel('RTT and packet loss rate (%)',fontsize=14)
#x_values.append(str(r)+', '+str(l)) # doesn't work for floating point
plt.xticks([1,2,3,4] , x_values)
plt.savefig(plot_dir+plot_name+'-rtt-loss-combined.png',format="png", bbox_inches='tight')


# =================== Heatmap of  RTT, loss combined =======================
qoe_combined =  []
for r in reversed(rtt):
    temp2 = []
    for l in loss:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        temp2.append(np.mean(temp[:,3]))
    qoe_combined.append(temp2)


plt.figure()
ax = sns.heatmap(qoe_combined, yticklabels=["150","50","0"], xticklabels=["0","0.05","1"],annot=True,cmap="YlGnBu",linewidths=.5)
ax.set(ylabel='RTT (ms)', xlabel='Packet loss rate %')
file_name=plot_name+"-heatmap"
plt.savefig(plot_dir+file_name+'.png',format="png", bbox_inches='tight')

# =================== Heatmap2 of  RTT, loss combined =======================
qoe_combined =  []
for r in reversed(rtt):
    temp2 = []
    for l in loss:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        temp2.append(np.mean(temp[:,3]))
    xx = qoe_combined.append(temp2)

trace = go.Heatmap(z=qoe_combined) #,
                   #x=["0","0.05","1"],
                   #y=["150","50","0"])
dd=[trace]
#py.offline.plot(d, auto_open=True)

fig = ff.create_annotated_heatmap(qoe_combined)
#py.offline.plot(fig, filename='annotated_heatmap')

# =================== plot RTT, loss mean  ========================
qoe_rtt = []
qoe_loss = []


#for loss plot
for r in rtt:
    temp2 = []
    for l in loss:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        temp2.append(np.mean(temp[:,3]))
    qoe_loss.append(temp2)
print "qoe loss", qoe_loss

#for rtt plot
for l in loss:
    temp2 = []
    for r in rtt:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        temp2.append(np.mean(temp[:,3]))
    qoe_rtt.append(temp2)


plt.figure()
plt.plot(rtt,qoe_rtt[0], 'gv-', label = 'loss rate: 0 %')
plt.plot(rtt,qoe_rtt[1], 'bo-', label = 'loss rate: 0.05 %')
plt.plot(rtt,qoe_rtt[2], 'mx-', label = 'loss rate: 1 %')
#plt.ylim((0,6))
plt.ylabel('MOS of video quality',fontsize=14)
plt.xlabel('RTT (ms)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.15))
plt.savefig(plot_dir+plot_name+'-mean-rtt-only.png',format="png", bbox_inches='tight')
#plt.xticks([1, 2, 3],rtt)

plt.figure()
plt.plot(loss,qoe_loss[0], 'gv-', label = 'RTT: 0 ms')
plt.plot(loss,qoe_loss[1], 'bo-', label = 'RTT: 50 ms')
plt.plot(loss,qoe_loss[2], 'mx-', label = 'RTT: 150 ms')
#plt.ylim((0,6))
plt.ylabel('MOS of video quality',fontsize=14)
plt.xlabel('Packet loss rate %',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.15))
#plt.xticks([1, 2, 3],rtt)
plt.savefig(plot_dir+plot_name+'-mean-loss-only.png',format="png", bbox_inches='tight')
#plt.show()

# =================== plot RTT, loss mean  degredation ========================
qoe_rtt = []
qoe_loss = []

#for loss plot
for r in rtt:
    temp2 = []
    for l in loss:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        temp2.append(np.mean(temp[:,3]))
    qoe_loss.append(temp2)
print "qoe loss", qoe_loss

#for rtt plot
for l in loss:
    temp2 = []
    for r in rtt:
        temp = data[np.where((data[:,1] == r) & (data[:,2] == l))]
        temp2.append(np.mean(temp[:,3]))
    qoe_rtt.append(temp2)


plt.figure()
plt.plot([0,(qoe_rtt[0][0]-qoe_rtt[0][1])/qoe_rtt[0][0] *100, (qoe_rtt[0][0]-qoe_rtt[0][2])/qoe_rtt[0][0] * 100], 'gv-', label = 'loss rate: 0 %')
plt.plot([0,(qoe_rtt[1][0]-qoe_rtt[1][1])/qoe_rtt[1][0] *100, (qoe_rtt[1][0]-qoe_rtt[1][2])/qoe_rtt[1][0] *100], 'bo-', label = 'loss rate: 0.05 %')
plt.plot([0,(qoe_rtt[2][0]-qoe_rtt[2][1])/qoe_rtt[2][0] *100, (qoe_rtt[2][0]-qoe_rtt[2][2])/qoe_rtt[2][0] *100], 'mx-', label = 'loss rate: 1 %')
#plt.ylim((0,6))
plt.ylabel('Decrease in performance %',fontsize=14)
plt.xlabel('RTT (ms)',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.15))
#plt.xticks([1, 2, 3],rtt)
plt.savefig(plot_dir+plot_name+'-degredaton-rtt-xaxis.png',format="png", bbox_inches='tight')

plt.figure()
plt.plot([0,(qoe_loss[0][0]-qoe_loss[0][1])/qoe_loss[0][0] *100, (qoe_loss[0][0]-qoe_loss[0][2])/qoe_loss[0][0] * 100], 'gv-', label = 'RTT: 0 ms')
plt.plot([0,(qoe_loss[1][0]-qoe_loss[1][1])/qoe_loss[1][0] *100, (qoe_loss[1][0]-qoe_loss[1][2])/qoe_loss[1][0] * 100], 'bo-', label = 'RTT: 50 ms')
plt.plot([0,(qoe_loss[2][0]-qoe_loss[2][1])/qoe_loss[2][0] *100, (qoe_loss[2][0]-qoe_loss[2][2])/qoe_loss[2][0] * 100], 'mx-', label = 'RTT: 150 ms')
#plt.ylim((0,6))
plt.ylabel('Decrease in performance %',fontsize=14)
plt.xlabel('Packet loss rate %',fontsize=14)
plt.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.15))
plt.savefig(plot_dir+plot_name+'-degredaton-loss-xaxis.png',format="png", bbox_inches='tight')

