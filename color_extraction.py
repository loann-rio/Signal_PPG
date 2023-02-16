# face detection 3.0

import cv2
import numpy as np

videoPath = r"" # enter path to video
eyeCascadePath = r"" # enter path to eyeCascade

video = cv2.VideoCapture(videoPath)

eyeCascade = cv2.CascadeClassifier(eyeCascadePath)  

def process_frame(frame, last_pos_eyes) -> tuple:
    # return average of each color as a tuple for a single frame

    pos_eyes = get_pos_eyes(frame, last_pos_eyes)

    if not pos_eyes:
        # the the pos is not defined, continue
        return None, None

    # to simplify, put the list of eyes from left to right
    if not pos_eyes[0][0] < pos_eyes[1][0]:
        pos_eyes = pos_eyes[::-1]


    # create a vector from left to right eye
    vx = pos_eyes[1][0] - pos_eyes[0][0]
    vy = pos_eyes[1][1] - pos_eyes[0][1]

    # get the lens of this vector
    lens = np.sqrt(vx**2+vy**2)

    # this give a new position for the face detection (only the forehead)
    new_pos_x = pos_eyes[0][0] + vx/2
    new_pos_y = pos_eyes[0][1] + vy/2 - lens/4

    # crop the image to the size of the new squarre [could be optimized]
    new_frame = frame[int(new_pos_y-3*lens/4):int(new_pos_y), int(new_pos_x-lens*1.5/2):int(new_pos_x+lens*1.5/2)]    

    # get the average of colors
    R = int(np.average(new_frame[:, :, 0]))
    G = int(np.average(new_frame[:, :, 1]))
    B = int(np.average(new_frame[:, :, 2]))

    return (R, G, B), pos_eyes


def get_pos_eyes(frame, last_pos_eyes:list[tuple]) -> list:
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) # get the frame in grey to help detection of eyes

    # detect position of eyes as a list
    eyes = eyeCascade.detectMultiScale(
        gray,
        scaleFactor=1.1,
        minNeighbors=60,
        minSize=(30, 30),
        flags=cv2.CASCADE_SCALE_IMAGE
    )

    if len(eyes) < 2:
        # if two eyes are not detected, we cannot find the new position, 
        # to simplify, we will just use the previous position
        return last_pos_eyes

    if len(eyes) > 2:
        # sometime, 3 points will be detected, we have to remove the non corrects ones
        # here we just remove the last one (surprisingly it's working) [should be changed to work anytime]
        eyes = eyes[:2]

    
    # simplify the position from a squarre to a single point 
    pos_eyes = []
    for (x, y, w, h) in eyes:
        # get center of the squarre
        pos_eyes.append((x+w/2, y+h/2)) 

    return pos_eyes

# last poss for the eyes
last_poss:tuple = None

# arrays of average colors of cropped frames of the video
R:list[int] = []
G:list[int] = []
B:list[int] = []

success, image = video.read()
while success:
    color, last_poss = process_frame(image, last_poss)

    if not color:
        # if the detection of the two eyes failed and there is not last values 
        # continue without doing anything. 
        continue

    R.append(color[0])
    G.append(color[1])
    B.append(color[2])

    # get next frame from video:
    success, image = video.read()


print('saving')
with open(r'save_list_colors.txt', 'w') as f:
    f.write(''.join([str(v)+' ' for v in R]) + '\n' + ''.join([str(v)+' ' for v in G]) + '\n' + ''.join([str(v)+' ' for v in B]))
print('done')