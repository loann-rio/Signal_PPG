##Copyright Loann&Nicolas 2023

##TODO:
##Power spectrum

clc #Clear terminal

data = dlmread('save_list_colors.txt',''); #-----------------------------------------Extract data from data text file
meanOfData = meanValue(data); #------------------------------------------------------Sum all values of data; mean() error "mean(6): out of bound 3 (dimensions are 3x1) (note: variable 'mean' shadows function)"
sDeviation = std(data')'; #----------------------------------------------------------Standard deviation function
processedData= xToxPrime(data,meanOfData,sDeviation);#-------------------------------normalized raw RGB traces
[delta,rowN]=findMinMax(processedData); #--------------------------------------------returns biggest difference min-max value and corresponding row number
validSignal=processedData(rowN,1:1:columns(processedData));#-------------------------equation (3)
heartBeatssignal=fft(validSignal);#--------------------------------------------------fast fourier transform
plot(0:1:length(heartBeatssignal)-1,heartBeatssignal(:))#----------------------------plot
