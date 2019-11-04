from flask import Flask, render_template
from flask_socketio import SocketIO
import urllib.request
import threading
import datetime
import time
import serial
import os
import binascii
import yaml

config = ""
with open('../config.yaml') as f:
    config = yaml.load(f, Loader=yaml.FullLoader)


# Config variables
COM_BAUDRATE = config["COM_BAUDRATE"]
COM_PORT = config["COM_PORT"]
BACKEND_PORT = config["BACKEND_PORT"]
BACKEND_IP = config["BACKEND_IP"]

# Flask Init
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins='*', async_mode='threading')
arduino = serial.Serial(port=COM_PORT, baudrate=COM_BAUDRATE, timeout=2)

def commandToString(cmd):
    
    try:
        command = list(config.keys())[list(config.values()).index(cmd)] 
    except:
        command = "UNKNOWN COMMAND"            
    msg = cmd + " ==> " + command
    return msg

@app.route("/")
def hello():
    return "Hello World!"


@app.route("/kill")
def kill():
    socketio.stop()
    return "Killed!"


@socketio.on('connect')
def handle_conncetion():
    print('')
    print('====== Client connected ======')
    print('')


@socketio.on('startRace')
def handle_message(args):
    print('received message: %s' % args)
    print('command sent: START RACE')
    buf = bytearray()
    buf.append(args)    
    arduino.write(buf)
    
@socketio.on('getStatus')
def getStatus(args):
    print('')
    print('=== New Message from Frontend === ')
    intargs = int(args)
    binargs = bin(args)
    print('received message:    %s' % commandToString(binargs))
 
    # print(bin(int(int(args),base=16)))

    buf = bytearray()
    buf.append(args)    
    arduino.write(buf)
    print('command sent to arduino')

def runArduino(name, socket):
    
    # emit an event
    print("=== Incoming Arduino Data: === ")    
    while True:
        #arduino.write(b"Hellos")
        data_raw = arduino.read()
        if(data_raw != b''):
            print("")
            print("=== Incoming Arduino Data: === ")
            # print(data_raw) 
            hexx = binascii.hexlify(data_raw)
            bindata = bin(int(hexx,base=16))        
            print(commandToString(bindata))          

            try:                            
                print("[OK]     Command Sent to frontend")
                socketio.emit('update', {'data': bindata})

                pass
            except:
                print("[ERROR]  Command Sent to frontend FAILED")
                pass

if __name__ == '__main__':
        
    arduino_thread = threading.Thread(
         target=runArduino, args=(1,socketio,), daemon=True)
    arduino_thread.start()
    socketio.run(app, host=BACKEND_IP, port=BACKEND_PORT, debug=True)
    
    