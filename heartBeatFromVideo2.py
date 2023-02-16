# graph colors variation

import matplotlib.pyplot as plt
import numpy as np
from sklearn.decomposition import FastICA, PCA


# import lists of values
with open(r'save_list_colors.txt', 'r') as f:
    t = f.read()

FS = 30.08 # fps of the video

R:list = []
G:list = []
B:list = []

t = t.split('\n') # split different colors

# range of frame taken into account in the video:
s = 0
f = 800 # 1623


R = [float(c) for c in t[0].split()[s:f]] # for each colors, split to get the final list of values
G = [float(c) for c in t[1].split()[s:f]]
B = [float(c) for c in t[2].split()[s:f]]


T = np.arange(0, len(R)/25, 1/25) # set list of time (we have a frequency of 25fps)

# standadisation:
std = np.std(G)
mean = np.mean(G)
newG:list = [(x-mean)/std for x in G]

std = np.std(R)
mean = np.mean(R)
newR:list = [(x-mean)/std for x in R]

std = np.std(B)
mean = np.mean(B)
newB:list = [(x-mean)/std for x in B]

# ICA:
# https://www.geeksforgeeks.org/blind-source-separation-using-fastica-in-scikit-learn/
# no idea what I am doing, stole it from webside above.
signalSumation = np.c_[newR, newG, newB]
signalSumation /= signalSumation.std(axis=0) 

mixMatrix = np.array(
    [[1, 1, 1], [0.8, 2, 1.2], [1.6, 1.2, 2.4]]) 
 
# Generate observations
obsvGenerate = np.dot(signalSumation, mixMatrix.T) 
ica = FastICA(n_components=3, whiten="arbitrary-variance")
signalRecont = ica.fit_transform(obsvGenerate)
mixMatrixEst = ica.mixing_  # Get estimated mixing matrix
assert np.allclose(obsvGenerate, np.dot(
    signalRecont, mixMatrixEst.T) + ica.mean_)
# compute PCA
pca = PCA(n_components=3)
orthosignalrecont = (pca.fit_transform(obsvGenerate)).T

# get the curve that is not noise, the one with the highest standard deviation
maincurve:list
for i in range(3):
    if np.std(orthosignalrecont[i]) > 3:
        maincurve = orthosignalrecont[i]


# get FFT and corresponding frequency
sp = np.fft.fft(newG)
freq = np.fft.fftfreq(800, 1/FS)

# get the frequency coresponding to the highest point in FFT
print('bpm=', 60*freq[list(np.abs(sp.real)).index(max((np.abs(sp.real)[:len(freq)//2])[25:200]))])


# plot the FFT  
plt.plot((freq[:len(freq)//2])[25:200], (np.abs(sp.real)[:len(freq)//2])[25:200])
plt.show()
