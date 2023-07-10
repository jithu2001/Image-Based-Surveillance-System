import cv2
import numpy as np
import os,uuid
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, __version__

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
                cv2.imwrite('face.jpg',img)
                box = faces[0, 0, i, 3:7] * np.array([width, height, width, height])
                (x, y, x1, y1) = box.astype("int")
                cv2.rectangle(img, (x, y), (x1, y1), (0, 0, 255), 2)
                if c==5:
                    try:
                        connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
                        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
                        blob_client = blob_service_client.get_blob_client(container="faceimg", blob="face.jpg")
                        print("\nUploading to Azure Storage as blob:\n\t face.jpg")
                        blob_client.delete_blob()
                        with open("face.jpg", "rb") as data:
                            blob_client.upload_blob(data)
                    except Exception as ex:
                        print('Exception:')
                        print(ex)
                c+=1
        cv2.imshow("dnn", img)
        if c>5 or cv2.waitKey(1) & 0xFF == ord('q'):
            break
    else:
        break         
cap.release()
cv2.destroyAllWindows()