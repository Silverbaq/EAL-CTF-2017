import sys
import os
import time
from flask import Flask
from flask import request
from flask import abort
import hashlib

def check_creds(user, pincode):
    if len(pincode) <= 8 and pincode.isdigit():
        val = '{}:{}'.format(user, pincode)
        key = hashlib.sha256(val).hexdigest()
        if key == '44c35d75f775d10fb9459751ab1b89e64ab705d009d2a17686c551b70fce11cc':
            return 'Congr4ts, you found the E@L-backdoor. The fl4g is simply : {}:{}'.format(user, pincode)
    return abort(404)


app = Flask(__name__)

@app.route('/')
def hello():
    return '<h1>HOME</h1>'


@app.route('/backdoor')
def backdoor():
    user = request.args.get('user')
    pincode = request.args.get('pincode')
    return check_creds(user, pincode)


if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=3333)

