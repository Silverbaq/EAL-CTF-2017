import socket
import sys
from threading import Thread
from random import randint

gip = 'ejp mysljylc kd kxveddknmc re jsicpdrysirbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcdde kr kd eoya kw aej tysr re ujdr lkgc jvzq'
eng = 'our language is impossible to understandthere are twenty six factorial possibilitiesso it is okay if you want to just give upqz'

gip_lines = [
'ejp mysljylc kd kxveddknmc re jsicpdrysi',
'rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd',
'de kr kd eoya kw aej tysr re ujdr lkgc jv',
'aynny iynny aynny iynny aynny iynny aynny iynny aynny iynny aynny iynny aynny iynny aynny ieeeeeeeee',
'y n f i c w l b k u o m x s e v z p d r j g a t h a q set k oset xa ynfd',
'schr rkxc tesr aej dksl tkrb xc',
'wep rbedc tbe dvcyo ks y resljc ie ser dvcyo re erbcp vcevmc',
'seneia jsicpdrysid rbcx dksfc rbca ypc dvcyoksl xadrcpkcd ks rbc dvkpkr',
'rbkd kd de chfkrksl k bygc re le rbc nyrbpeex',
'kr tyd rbc ncdr ew rkxcd kr tyd rbc nmjpdr ew rkxcd',
'mcr mkvd ie tbyr bysid ie',
'rbkd bcpc kd ljsveticp yfrkgyrci rtcsra dcgcs fymkncp wjmm yjre se okfonyfo sykmrbpetksl xyabcx',
'k bygc ncdrci wpjkr dvkoc ysi xees set k dbymm ncdr aej rbc lja',
'ys cac wep ys cac ysi y vklces wep y vklces',
'ymm aejp nydc ypc ncmesl re cppep rbc dveesa nypi',
'aej vkddci eww rbc fbkfocs myia',
'set kd rbc djxxcp ew ejp myfo ew ikdfesrcsr',
'na rbc vpkfoksl ew xa rbjxnd dexcrbksl tkfoci rbkd tya fexcd',
'ks y tepmi ew ikpctemgcd ysi mkesd dexcrkxcd rbc pypcdr fpcyrjpc kd y wpkcsi',
'lpccrksld fbccdc vevdkfmc rbc sjxncp aej bygc ikymci kd fjppcsrma ejr ew vepofbevd',
'tba ie vpelpyxxcpd ymtyad xkh jv bymmetccs ysi fbpkdrxyd',
'w ew rte czjymd w ew esc czjymd esc',
'wep k ncrtccs rbpcc ysi s w ew k czjymd w ew k xksjd esc vmjd w ew k xksjd rte',
'bet ypc aej bemiksl jv ncfyjdc kx y veryre',
'tbeeeeeeeeeeeeeeeeeeeyyyyyyyyy k oset f vmjd vmjd',
'schr rkxc k tkmm ser nc drysiksl drkmm tbkmc rbca veksr',
'kd rbkd rbc ncdr tya ysaesc fys dvcsi y sepxym tcco iya',
'dexcrkxcd k dxcmm xa ets wyprd ysi csuea rbc xepsksl ywrcp',
'wep xepc rbcs dcgcs acypd k bygc ser dmccvr tkrbejr bygksl sklbrxypcd',
'de rbkd kd tbyr rbca fymm djxxcp wjs',
'set rbca oset tbcpc re wksi cxvra fys nerrmcd rbyr fys dygc rbc jskgcpdc',
'sepxymma tbcs k tyrfb rcmcgkdkes kr byd dexcrbksl re ie tkrb xa wpkcsid',
'rexeppet kd rbc wkpdr iya wep rbc pcdr ew rbc tcco',
'vkso byd ymtyad nccs rbc femep ew aejp wygepkrc rcmcrjnnkc',
'rbcpc kd ymxedr xepc rbcs wkgc ikwwcpcsr wkdb ks rbc tepmi',
'k bygc nccs ks rbc fkra wep y acyp set ysi k yx medr',
'reiya kd rbc vcpwcfr iya re drypr dxeoksl fpyfo',
'tbcs k dcc y nymmees k ymtyad teppa rbyr xesocad tkmm drypr re rbpet iyprd',
'kd rbkd pcymma ser rbc ncdr weernymm k fejmi wksi njr k ie ser fypc',
'iefrepd fymm xc rbc tesicp wpex ynegc',
'cgcpa dksfc k dryprci vpelpyxxksl k fys ser wksi y leei csejlb xyrc',
'tbeeeeee ieeeeeeee aejjjjjj rbksoooooo aejjjjjjjj ypcccccc',
'djvcplkpm gd djvcpxys czjym djvcpokid',
'rbkd dfbeem kd rbc ncdr vmyfc re dvcsi rkxc kw k fejmi esma dmccv bcpc k tejmi nc ks bcygcs',
'dees se esc fys lcr bexc wpex tepo dksfc rbc njd kd ser ipkgksl ysaxepc',
'ypc rksa yskxymd ser ujdr dexcrbksl vcevmc rbkso chkdr'

]


class ClientHandler(object):
    def __init__(self, connection, client_address):
        self.connection = connection
        self.client_address = client_address

    def translate_to_eng(self, line):
        result = ''
        for x in line:
            i = gip.index(x)
            result += eng[i]
        return result

    def translate_to_gip(self, line):
        result = ''
        for x in line.strip():
            i = eng.index(x)
            result += gip[i]
        return result


    def get_gip_line(self):
        return gip_lines[randint(0,len(gip_lines)-1)]


    def check_solution(self, eng, gip):
        return eng == gip

    def game(self):
        try:
            flawless = True
            for i in range(30): # Give 30 sum questions
                line = self.get_gip_line()
                self.connection.sendall('{}\n'.format(line))

                data = self.connection.recv(1024)
                if not self.check_solution(self.translate_to_gip(data), line):
                    flawless = False

            if flawless:
                self.connection.sendall('You are CORRECT!!! {}'.format('eal{Ev3ry0ne_ShoUld_LeaRn_2_ReaD}'))
            else:
                self.connection.sendall('WRONG ANSWER!')

        finally:
            # Clean up the connection
            self.connection.close()


class GiparishServer(object):
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
    server = GiparishServer('0.0.0.0', 11103)
    server.start_server()