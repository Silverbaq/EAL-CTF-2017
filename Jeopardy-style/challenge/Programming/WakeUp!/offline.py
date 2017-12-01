#!/usr/bin/python2
import networkx as nx

graph = nx.Graph()


def main():
    for line in open('input', 'r'):
        line = line.strip()
        #print('received: %s' % line)

       # if line.startswith(b'eal{') or \
       #                 line == b'WRONG ANSWER': break

        numbers = list(map(int, line.split()))

        # build graph
        if len(numbers) == 3:
            graph.add_node(numbers[0])
            graph.add_node(numbers[1])
            graph.add_edge(numbers[0], numbers[1], weight=numbers[2])
        elif len(numbers) == 2:
            s = nx.dijkstra_path_length(graph, numbers[0], numbers[1])  # Checking result
            #f.write(('%d\n' % s).encode('utf-8'))
            print('sent: %d' % s)  # for debugging purposes


main()