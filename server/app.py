from flask import Flask, render_template
from flask_socketio import SocketIO
import urllib.request
import threading
import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins="*")


@app.route("/")
def hello():
    return "Hello World!"


@socketio.on('hello')
def handle_message(args):
    print('received message: %s' % args)
    socketio.emit('news', {'data': str(
        datetime.datetime.now())}, broadcast=True)


if __name__ == '__main__':
    socketio.run(app, host="127.0.0.1", port=10002)

# @socketio.on('connect')
# def test_connect():
#     socketio.send('hello', {'from': 'Connected', 'msg': 'dsdsd'})
