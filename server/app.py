from flask import Flask, render_template
from flask_socketio import SocketIO
import urllib.request
import threading
import datetime
import pyfirmata
import time

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins='*')


def runSocketIO():
    print("sss")
    socketio.run(app, host="127.0.0.1", port=10002)


@app.route("/")
def hello():
    return "Hello World!"


@socketio.on('hello')
def handle_message(args):
    print('received message: %s' % args)
    socketio.emit('news', {'data': str(
        datetime.datetime.now())}, broadcast=True)


def runArduino():
    board = pyfirmata.Arduino('COM4')
    sw = board.get_pin('d:2:i')
    led = board.get_pin('d:13:o')
    it = pyfirmata.util.Iterator(board)
    it.start()
    while True:
        value = sw.read()
        if value:
            led.write(1)
            socketio.emit('update', {'data': str(
                datetime.datetime.now())}, broadcast=True)
        else:
            led.write(0)
    board.exit()


if __name__ == '__main__':
    s = runSocketIO()
    s.daemon = True
    s.start()
    f = runArduino()
    f.daemon = True
    f.start()

    while True:
        time.sleep(1)

    # threading.Thread(target=runArduino).start()
    # threading.Thread(target=runSocketIO).start()
# @socketio.on('connect')
# def test_connect():
#     socketio.send('hello', {'from': 'Connected', 'msg': 'dsdsd'})
