#!/usr/bin/python2
import ssl, socket

class Connect(object):
    def __init__(self, host, port):
        self.conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.conn.connect((host, port))
        self.f = self.conn.makefile('rwb', 0)
    def __enter__(self):
        return self.f
    def __exit__(self, type, value, traceback):
        self.f.close()



import networkx as nx

graph = nx.Graph()

with Connect('jlab13.eal.dk', 11102) as f:
    for line in f:
        line = line.strip()
        print('received: %s' % line)

        if line.startswith(b'eal{') or \
           line == b'WRONG ANSWER': break

        numbers = list(map(int, line.split()))

        #build graph
        if len(numbers) == 3:
            graph.add_node(numbers[0])
            graph.add_node(numbers[1])
            graph.add_edge(numbers[0], numbers[1], weight=numbers[2])
        elif len(numbers) == 2:
            s = nx.dijkstra_path_length(graph, numbers[0], numbers[1])  # Checking result
            f.write(('%d\n' % s).encode('utf-8'))
            print('sent: %d' % s)  # for debugging purposes
