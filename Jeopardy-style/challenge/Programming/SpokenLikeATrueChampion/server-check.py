import socket

gip = 'ejp mysljylc kd kxveddknmc re jsicpdrysirbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcdde kr kd eoya kw aej tysr re ujdr lkgc jvzq'
eng = 'our language is impossible to understandthere are twenty six factorial possibilitiesso it is okay if you want to just give upqz'


def translate(line):
    current = ''
    try:
        result = ''
        for x in line:
            current = x
            i = gip.index(x)
            result += eng[i]
        return result
    except:
        print('error with: {}'.format(current))


def main():
    TCP_IP = 'jlab13.eal.dk'
    TCP_PORT = 11103
    BUFFER_SIZE = 1024


    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((TCP_IP, TCP_PORT))

    for i in range(0,31):
        data = s.recv(BUFFER_SIZE).strip().decode("utf-8")
        print(data)
        msg = translate(data)
        print(msg)
        s.send(msg.encode())


    s.close()


main()