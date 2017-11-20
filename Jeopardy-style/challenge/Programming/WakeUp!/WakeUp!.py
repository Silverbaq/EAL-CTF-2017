import socket
import sys
from threading import Thread
from random import randint
import networkx as nx


class ClientHandler(object):
    def __init__(self, connection, client_address):
        self.connection = connection
        self.client_address = client_address

    def make_edge(self, node_range):
        a = randint(1,node_range)
        b = a
        while b == a:
            b = randint(1,node_range)
        c = randint(1,100)
        return (a,b,c)

    def build_graph(self):
        self.G = nx.Graph()
        amount_of_nodes = randint(15,20)
        [self.G.add_node(x) for x in range(1,amount_of_nodes+1)] # Adding nodes
        amount_of_edges = randint(10,15)
        self.edges = [self.make_edge(amount_of_nodes) for x in range(amount_of_edges+10)] # Make all the edges
        self.G.add_weighted_edges_from(self.edges)

    def get_a_path(self, node_range):
        works = False
        while not works: # Checks if path is in graph
            a = randint(1, node_range)
            b = randint(1, node_range)

            if nx.has_path(self.G, a,b):
                works = True
        return a,b

    def game(self):
        try:
            flawless = True
            self.build_graph()
            for x in self.edges: # Send the edges/nodes + weight
                self.connection.sendall('{} {} {}\n'.format(x[0], x[1], x[2]))

            for i in range(20): # Start asking for shortest path between nodes
                number_of_nodes = self.G.number_of_nodes()
                path_a, path_b = self.get_a_path(number_of_nodes)
                self.connection.sendall('{} {}\n'.format(path_a, path_b)) # Send question
                data = self.connection.recv(16) # Recive answer

                try:
                    if int(data.rstrip()) != nx.dijkstra_path_length(self.G,path_a, path_b): # Checking result
                        flawless = False
                except:
                    flawless = False

            if flawless:
                self.connection.sendall('You are CORRECT!!! {}'.format('eal{I_aM_On_Th3_R1gHt_PaTh}\n'))
            else:
                self.connection.sendall('WRONG ANSWER!\n')

        finally:
            # Clean up the connection
            self.connection.close()


class PathServer(object):
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
            connection.settimeout(10)
            client_handler = ClientHandler(connection, client_address)
            Thread(target=client_handler.game).start()


if __name__ == "__main__":
    server = PathServer('0.0.0.0', 11102)
    server.start_server()