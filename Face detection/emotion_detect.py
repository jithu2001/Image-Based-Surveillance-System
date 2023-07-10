from deepface import DeepFace
import cv2
import matplotlib.pyplot as plt

img1=cv2.imread(r'D:\face\face.jpg')
result= DeepFace.analyze(img1, actions = ['emotion'])
print(result['dominant_emotion'])