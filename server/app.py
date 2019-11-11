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
import logging
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

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
arduino = serial.Serial(port=COM_PORT, baudrate=COM_BAUDRATE, timeout=1)

def commandToString(cmd):
    
    try:
        command = list(config.keys())[list(config.values()).index(cmd)] 
    except:
        command = "UNKNOWN COMMAND"            
    msg = cmd + " ==> " + command
    return msg

def millisToRaceTime(ms):
    millis=int((ms)%1000)
    seconds=int((ms/1000)%60)
    minutes=int((ms/(1000*60))%60)
    hours=int((ms/(1000*60*60))%24)
    time = ("%s:%s:%s.%s" % (str(hours).zfill(2), str(minutes).zfill(2), str(seconds).zfill(2), str(millis).zfill(3)))
    return time

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

    intargs = int(args)
    binargs = bin(args)
    buf = bytearray()
    buf.append(args)    
    arduino.write(buf)
    if(binargs == config["GET_RACE_TIME"]):
        return
  
    print('')
    print('=== New Message from Frontend === ')
    print('received message:    %s' % commandToString(binargs))
    print('command sent to arduino')

def binary(num, pre='0b', length=16, spacer=0):
    return '{0}{{:{1}>{2}}}'.format(pre, spacer, length).format(bin(num)[2:])

def runArduino(name, socket):
    
    # emit an event
    print("=== Incoming Arduino Data: === ")    
    while True:
        #arduino.write(b"Hellos")
        data_raw = arduino.read(1)

                
        if(data_raw != b''):
      
            hexx = binascii.hexlify(data_raw)
            data_str = binary(int(hexx,base=16),length=8)
        
            # If we need more bytes do it now process 64-bits
            if(data_str == config["GET_RACE_TIME"]):
                # print("This shpud print the current time")      
                data64 = arduino.read(8)
                hexx = binascii.hexlify(data64)
                data64_str = binary(int(hexx,base=16),length=64)
                millis = int(hexx,base=16)
                time = millisToRaceTime(millis)
                # print(data64_str)
                socketio.emit('raceTime', {'data': time})
                # print(time)
                continue

            print("")
            print("=== Incoming Arduino Data: === ")      
            print(commandToString(data_str)) 
            print("")
            
            ## Else continue with 1 Byte commands                    
            try:                            
                print("[OK]     Command Sent to frontend")
                socketio.emit('update', {'data': data_str})
                pass
            except:
                print("[ERROR]  Command Sent to frontend FAILED")                
                pass

if __name__ == '__main__':
        
    arduino_thread = threading.Thread(
         target=runArduino, args=(1,socketio,), daemon=True)
    arduino_thread.start()
    socketio.run(app, host=BACKEND_IP, port=BACKEND_PORT, debug=True)
    
    