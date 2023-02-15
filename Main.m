##Copyright Loann&Nicolas 2023

clc #Clear terminal
close all
clear all


data = dlmread("C:/Users/loann/Desktop/codes/python/save_list_colors.txt",''); #-----------------------------------------Extract data from data text file
Fs = 25;% 30.08; % FPS of the video


meanOfData = mean(data, 2); % get average of each row
sDeviation = std(data')'; #----------------------------------------------------------Standard deviation function
processedData = (data-meanOfData)./sDeviation; #-------------------------------normalized raw RGB traces
[W, s, v] = svd((repmat(sum(processedData.*processedData,1),size(processedData,1),1).*processedData)*processedData'); % ICA of our signal
signalAfterICA = W*processedData;

curve1 = abs(fft(signalAfterICA(1, 1:30*Fs)));
curve2 = abs(fft(signalAfterICA(2, 1:30*Fs)));
curve3 = abs(fft(signalAfterICA(3, 1:30*Fs)));

curves = [curve1; curve2; curve3];

% get the curve with the highest svd
maxSvd = 0; 
for i = 1:3;
  if (svd(curves(i, :))> maxSvd)
    finalCurve = curves(i, :);
    maxSvd = svd(finalCurve);
    i
  endif
 endfor

% heartBeatsSignal = abs(fft(signalAfterICA(:, 1:750), 3))(1:20)#--------------------------------------------------fast fourier transform




#heartBeatsSignal = abs(fft(processedData(2, 1:750)));#--------------------------------------------------fast fourier transform
%processedData (1:20)
N = length(finalCurve);
frequency = (0:N-1)*Fs/N;

%%% crop the signal to the part that interest us:
fMin = 0.6
fMax = 4

% find corresponding index on f
indexMin = find(frequency >= fMin, 1);
indexMax = find(frequency <= fMax, 1, 'last');
%%%

[val_max, idx] = max(finalCurve(indexMin:indexMax));
freq_max = frequency(indexMin:indexMax)(idx);
fprintf("BPM : %f\n", freq_max*60);

plot(frequency(indexMin:indexMax),finalCurve(indexMin:indexMax))#----------------------------plot
