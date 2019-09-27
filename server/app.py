from flask import Flask, render_template
from flask_socketio import SocketIO
import urllib.request
import threading
import datetime
import pyfirmata
import time
import serial

# COM4 19200


app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins='*')


@app.route("/")
def hello():
    return "Hello World!"


@app.route("/kill")
def kill():
    socketio.stop()
    return "Killed!"


@socketio.on('hello')
def handle_message(args):
    print('received message: %s' % args)
    socketio.emit('news', {'data': str(
        datetime.datetime.now())}, broadcast=True)


def runArduino(name):
    arduino = serial.Serial(port='COM4', baudrate=19200, timeout=2)
    while True:
        data_raw = arduino.read(3)
        print(data_raw)
    # board = pyfirmata.Arduino('COM4')
    # sw = board.get_pin('d:2:i')
    # led = board.get_pin('d:13:o')
    # it = pyfirmata.util.Iterator(board)
    # it.start()
    # while True:
    #     value = sw.read()
    #     if value:
    #         led.write(1)
    #         socketio.emit('update', {'data': str(
    #             datetime.datetime.now())}, broadcast=True)
    #     else:
    #         led.write(0)
    # board.exit()

# def runSocketIO(name):
#     socketio.run(app, host="127.0.0.1", port=10002)


if __name__ == '__main__':
    # threading.Thread(target=app.run).start()
    arduino_thread = threading.Thread(
        target=runArduino, args=(1,), daemon=True)
    arduino_thread.start()
    socketio.run(app, host="127.0.0.1", port=10002)

    # socket_thread = threading.Thread(
    #     target=runSocketIO, args=(1,), daemon=True)
    # arduino_thread = threading.Thread(
    #     target=runArduino, args=(2,), daemon=True)

    # # socket_thread.start()
    # arduino_thread.start()
    # time.sleep(5)

    # threading.Thread(target=runArduino).start()
    # threading.Thread(target=runSocketIO).start()
# @socketio.on('connect')
# def test_connect():
#     socketio.send('hello', {'from': 'Connected', 'msg': 'dsdsd'})
