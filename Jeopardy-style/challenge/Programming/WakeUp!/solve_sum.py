#!/usr/bin/python2
import ssl, socket

class Connect(object):
    def __init__(self, host, port):
        self.context = ssl.create_default_context()
        self.conn = self.context.wrap_socket(
            socket.socket(socket.AF_INET),
            server_hostname=host)
        self.conn.connect((host, port))
        self.f = self.conn.makefile('rwb', 0)
    def __enter__(self):
        return self.f
    def __exit__(self, type, value, traceback):
        self.f.close()

with Connect('INSERT_ADDRESS', PORT_AS_AN_INT) as f:
    for line in f:
        line = line.strip()
        print('received: %s' % line)

        if line.startswith(b'CTF-BR{') or \
           line == b'WRONG ANSWER': break

        numbers = map(int, line.split())
        s = sum(numbers)

        f.write(('%d\n' % s).encode('utf-8'))
        print('sent: %d' % s)  # for debugging purposes
