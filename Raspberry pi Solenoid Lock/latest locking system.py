import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import RPi.GPIO as GPIO
import time  

cred = credentials.Certificate('solenoid-lock-7daae-firebase-adminsdk-ip6g5-670062e563.json')
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://solenoid-lock-7daae-default-rtdb.asia-southeast1.firebasedatabase.app/'
})
ref = db.reference('/')
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

lock_pin = 18  
GPIO.setup(lock_pin, GPIO.OUT)

def unlock():
    GPIO.output(lock_pin, GPIO.LOW)
    print("Unlocking...")
    time.sleep(5)  
    GPIO.output(lock_pin, GPIO.LOW)
    print("Unlocked.")

def lock():
    GPIO.output(lock_pin, GPIO.HIGH)
    print("locking...")
    time.sleep(5)  
    GPIO.output(lock_pin, GPIO.HIGH)
    print("locked")

while True:
    value = ref.get()
    if value == 1:
        lock()  
        time.sleep(10)  # wait for 10 seconds
    else:
        unlock()  
        time.sleep(10)
    GPIO.cleanup()
