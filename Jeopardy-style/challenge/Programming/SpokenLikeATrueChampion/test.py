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


def translate_to_gip(line):
    result = ''
    for x in line:
        i = eng.index(x)
        result += gip[i]
    return result


lines = [
    'ejp mysljylc kd kxveddknmc re jsicpdrysi',
    'rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd',
    'de kr kd eoya kw aej tysr re ujdr lkgc jv',
    'hello i am the google code jam test data',
    'how are you',
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
    'eb byk kx ks jp fexvjrcp cyrksl aejp fbccqnjplcpd ysi leelmcpcdksl aejp rchrq',
    'ys cac wep ys cac ysi y vklces wep y vklces',
    'ymm aejp nydc ypc ncmesl re cppep rbc dveesa nypi',
    'aej vkddci eww rbc fbkfocs myia',
    'set kd rbc djxxcp ew ejp myfo ew ikdfesrcsr',
    'na rbc vpkfoksl ew xa rbjxnd dexcrbksl tkfoci rbkd tya fexcd',
    'ks y tepmi ew ikpctemgcd ysi mkesd dexcrkxcd rbc pypcdr fpcyrjpc kd y wpkcsi',
    'lpccrksld fbccdc vevdkfmc rbc sjxncp aej bygc ikymci kd fjppcsrma ejr ew vepofbevd',
    'tba ie vpelpyxxcpd ymtyad xkh jv bymmetccs ysi fbpkdrxyd',
    'kx fexxysicp dbcvypi ysi rbkd kd xa wygepkrc vpenmcx es rbc leelmc feic uyx',
    'w ew rte czjymd w ew esc czjymd esc',
    'wep k ncrtccs rbpcc ysi s w ew k czjymd w ew k xksjd esc vmjd w ew k xksjd rte',
    'bet ypc aej bemiksl jv ncfyjdc kx y veryre',
    'ip qykjd ip qykjd ip qykjd ip qykjd eeeeeeeeeeeeb ip qykjd',
    'tbeeeeeeeeeeeeeeeeeeeyyyyyyyyy k oset f vmjd vmjd'
]

new_lines = [
    'our language is impossible to understand',
    'there are twenty six factorial possibilities',
    'so it is okay if you want to just give up',
    'yabba dabba yabba dabba yabba dabba yabba dabba yabba dabba yabba dabba yabba dabba yabba dooooooooo',
    'a b c d e f g h i j k l m n o p q r s t u v y w x y z now i know my abcs',
    'next time wont you sing with me',
    'for those who speak in a tongue do not speak to other people',
    'nobody understands them since they are speaking mysteries in the spirit',
    'this is so exciting i have to go the bathroom',
    'it was the best of times it was the blurst of times',
    'let lips do what hands do',
    'this here is gunpowder activated twenty seven caliber full auto no kickback nailthrowing mayhem',
    'i have bested fruit spike and moon now i shall best you the guy',
    'an eye for an eye and a pigeon for a pigeon',
    'all your base are belong to error the spoony bard',
    'you pissed off the chicken lady',
    'now is the summer of our lack of discontent',
    'by the pricking of my thumbs something wicked this way comes',
    'in a world of direwolves and lions sometimes the rarest creature is a friend',
    'greetings cheese popsicle the number you have dialed is currently out of porkchops',
    'why do programmers always mix up halloween and christmas',
    'f of two equals f of one equals one',
    'for i between three and n f of i equals f of i minus one plus f of i minus two',
    'how are you holding up because im a potato',
    'whoooooooooooooooooooaaaaaaaaa i know c plus plus',
    'next time i will not be standing still while they point',
    'is this the best way anyone can spend a normal week day',
    'sometimes i smell my own farts and enjoy the morning after',
    'for more then seven years i have not sleept without having nightmares',
    'so this is what they call summer fun',
    'now they know where to find empty can bottles that can save the universe',
    'normally when i watch television it has something to do with my friends',
    'tomorrow is the first day for the rest of the week',
    'pink has always been the color of your favorite teletubbie',
    'there is almost more then five different fish in the world',
    'i have been in the city for a year now and i am lost',
    'today is the perfect day to start smoking crack',
    'when i see a balloon i always worry that monkeys will start to throw darts',
    'is this really not the best football i could find but i do not care',
    'doctors call me the wonder from above',
    'every since i started programming i can not find a good enough mate',
    'whoooooo doooooooo youuuuuu thinkkkkkk youuuuuuuu areeeeee',
    'supergirl vs superman equal superkids',
    'this school is the best place to spend time if i could only sleep here i would be in heaven',
    'soon no one can get home from work since the bus is not driving anymore',
    'are tiny animals not just something people think exist'
]

for line in new_lines:
    print(translate_to_gip(line))
