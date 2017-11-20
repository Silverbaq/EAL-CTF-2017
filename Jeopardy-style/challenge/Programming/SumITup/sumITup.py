import socket
import sys
from threading import Thread
from random import randint


class ClientHandler(object):
    def __init__(self, connection, client_address):
        self.connection = connection
        self.client_address = client_address

    def game(self):
        try:
            flawless = True
            for i in range(30): # Give 30 sum questions
                a = randint(1,100)
                b = randint(1,100)
                self.connection.sendall('{} {}\n'.format(a,b))

                data = self.connection.recv(16)
                if a+b is not int(data.rstrip()):
                    flawless = False

            if flawless:
                self.connection.sendall('You are CORRECT!!! {}'.format('eal{I_kNoW_HoW_tO_SuM_W1Th_My_CoMpUtEr!}'))
            else:
                self.connection.sendall('WRONG ANSWER!')

        finally:
            # Clean up the connection
            self.connection.close()


class SumServer(object):
    def __init__(self, address, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_address = (address, port)


    def start_server(self):
        print >> sys.stderr, 'starting up on %s port %s' % self.server_address
        self.sock.bind(self.server_address)

        # Listen for incoming connections
        self.sock.listen(1)

        while True:
            # Wait for a connection
            print >> sys.stderr, 'waiting for a connection'
            connection, client_address = self.sock.accept()
            print >> sys.stderr, 'connection from', client_address
            connection.settimeout(5)
            client_handler = ClientHandler(connection, client_address)
            Thread(target=client_handler.game).start()


if __name__ == "__main__":
    server = SumServer('0.0.0.0', 11101)
    server.start_server()