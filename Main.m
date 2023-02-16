##Copyright Loann&Nicolas 2023

clc #Clear terminal
close all
clear all


data = dlmread("C:/Users/loann/Desktop/codes/python/save_list_colors.txt",''); # Extract data from data text file
Fps = 30.08; % FPS of the video

meanOfData = mean(data, 2); % get average of each row
sDeviation = std(data')'; # Standard deviation function
processedData = (data-meanOfData)./sDeviation; # normalized raw RGB traces

% source ICA: https://www.reddit.com/r/MachineLearning/comments/2heisq/one_line_code_of_independent_component_analysis/
[W, s, v] = svd((repmat(sum(processedData.*processedData,1),size(processedData,1),1).*processedData)*processedData'); % ICA of our signal
signalAfterICA = W*processedData;

% get the curve with the max svd ( the one that is not noise )
SVDcurve1 = svd(signalAfterICA(1, 1:30*Fps));
SVDcurve2 = svd(signalAfterICA(2, 1:30*Fps));
SVDcurve3 = svd(signalAfterICA(3, 1:30*Fps));
curves = [SVDcurve1 SVDcurve2 SVDcurve3];
[max_values indices] = max(curves);

% apply fft to the right curve
finalCurve = abs(fft(signalAfterICA(indices, 1:30*Fps)));

N = length(finalCurve);
frequency = (0:N-1)*Fps/N;

%%%% crop the signal to the part that interest us:
fMin = 0.6;
fMax = 4;

% find corresponding index on f
indexMin = find(frequency >= fMin, 1);
indexMax = find(frequency <= fMax, 1, 'last');
%%%

[val_max, idx] = max(finalCurve(indexMin:indexMax)); % find the maximum point of the curve 
freq_max = frequency(indexMin:indexMax)(idx); % find the corresponding frequency
fprintf("BPM : %f\n", freq_max*60); % show the frequency
