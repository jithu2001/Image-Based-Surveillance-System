import pyrebase  
import cv2
import numpy as np

config = {
  "apiKey": "AIzaSyAmbiSQ6LDqUPI_RPoJZBl6l16DUL5lP8U",
  "authDomain": "image-9369d.firebaseapp.com",
  "projectId": "image-9369d",
  "storageBucket": "image-9369d.appspot.com",
  "messagingSenderId": "446217437682",
  "appId": "1:446217437682:web:42a98240b46d2645afab6b",
  "serviceaccount": "serviceaccount.json",
  "databaseURL": "https://image-9369d-default-rtdb.firebaseio.com/"
}
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()
#import time
modelFile = "models/res10_300x300_ssd_iter_140000.caffemodel"
configFile = "models/deploy.prototxt.txt"
net = cv2.dnn.readNetFromCaffe(configFile, modelFile)
cap=cv2.VideoCapture(0)
if not cap.isOpened():
    print("[Exiting]: Error accessing webcam stream.")
    exit(0)
c=1
while(True):
    ret, img = cap.read()
    if ret == True:
        height, width = img.shape[:2]
        blob = cv2.dnn.blobFromImage(cv2.resize(img, (300, 300)),1.0, (300, 300), (104.0, 117.0, 123.0))
        net.setInput(blob)
        faces = net.forward()
        for i in range(faces.shape[2]):
            confidence = faces[0, 0, i, 2]
            if confidence > 0.5:
                #cv2.imwrite('frame%d.jpg'%c,img)
                cv2.imwrite('face.jpg',img)
                c+=1
                box = faces[0, 0, i, 3:7] * np.array([width, height, width, height])
                (x, y, x1, y1) = box.astype("int")
                cv2.rectangle(img, (x, y), (x1, y1), (0, 0, 255), 2)
                #time.sleep(1)
        cv2.imshow("dnn", img)
        if cv2.waitKey(1) & 0xFF == ord('q') or c>5:
            break
    else:
        break         
cap.release()
cv2.destroyAllWindows()
storage.child("face.jpg").put("face.jpg")