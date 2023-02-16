# Signal_PPG
This project is about getting a heartbeat from a given video.
It's divided in two parts: getting colors from the video (color_extraction.py)
get Bpm from colors ( heartBeatFromVideo2.py and Main.m)
the second part is made by two different code doing the same thing with a slightly better result in python.

project status: completed

Use instruction:
In first part, insert the video path and a path to a eyeCascade, it will update save_list_colors.txt
in the ssecond part, enter the frequency of the video (FPS) and it will print the BPM

necessary package:
octave: None
Python: CV2, numpy, matplotlib, sklearn
