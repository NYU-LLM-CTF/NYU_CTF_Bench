import socket
import socketserver
import threading
import time
import random
import errno
import sys
import base64
import re

random.seed(time.time())

itermre = re.compile(r'=[0-9A-F]{2,200}')
fpre = re.compile('([^c]*)c([^t]*)t*')

DEBUG = False
HARDER = True
EXTRAHARD = True

ESC='\033'
CSI = ESC + '['
DCS = ESC + "P" #Terminated by ST
ST = ESC + "\\"
OSC = ESC + ']'
SOS = ESC + 'X'
BEL = '\007'
FINGERPRINT=ESC+'>0c'

CHARATTRIB = {'normal':    '0',
              'bold':      '1',
              'faint':     '2',
              'italic':    '3',
              'underline': '4',
              'blink':     '5',
              'inverse':   '7',
              'hidden':    '8',
              'crossed':   '8',
              'normal48':  '48',
}


BGCOLORS = {'black':   '40',
            'red':     '41',
            'green':   '42',
            'yellow':  '43',
            'blue':    '44',
            'magenta': '45',
            'cyan':    '46',
            'white':   '47',
            'default': '49',
}

FGCOLORS = {'black':   '30',
            'red':     '31',
            'green':   '32',
            'brightgreen':   '92',
            'yellow':  '33',
            'blue':    '34',
            'magenta': '35',
            'cyan':    '36',
            'white':   '37',
            'default': '39',
}

CURSORSTYLE = {'blinkingblock':     '0',
               'steadyblock':       '2',
               'blinkingunderline': '3',
               'steadyunderline':   '4',
               'blinkingbar':       '5',
               'steadybar':         '6',
}


def CURSOROFF():
    return CSI + '?25l'

def CURSORON():
    return CURSOR('blinkingbar')


def BG(color):
    colors = {**BGCOLORS, **CHARATTRIB}
    return CSI + colors[color] + 'm'

def FG(color):
    colors = {**FGCOLORS, **CHARATTRIB}
    return CSI + colors[color] + 'm'

def CURSOR(style):
    return CSI + CURSORSTYLE[style] + ' q'

def INVISIBLE():
    return CSI + '?25l'

def VISIBLE():
    return CSI + '?25h'

def UP(count):
    if count == 0:
        return ''
    return random.choice([
        CSI + str(count) + 'A',
        (CSI + '1A') * count,
])

def DOWN(count):
    if count == 0:
        return ''
    return random.choice([
        CSI + str(count) + 'B',
        (CSI + '1B') * count,
])

def LEFT(count):
    if count == 0:
        return ''
    if random.randint(1,4) == 1:
        return CSI + str(count) + 'D'
    else:
        out = ''
        while (count >= 1):
            out += random.choice([
        '\010',
        (CSI + '1D'),
])
            count -= 1
        return out

def RIGHT(count):
    if count == 0:
        return ''
    return random.choice([
        CSI + str(count) + 'C',
        (CSI + '1C') * count,
])

def DEL(count):
    if count == 0:
        return ''
    return random.choice([
        (CSI + '3~') * count
])

def BACKSPACE(count):
    if count == 0:
        return ''
    return random.choice([
        LEFT(count) + DEL(count),
        '\010' * count,
])

def GOTO(x,y):
    return random.choice([
        CSI + str(y) + ";" + str(x) + "H",
        CSI + str(y) + ";" + str(x) + "f",
        CSI + str(y) + 'd' + CSI + str(x) + "G",
    ])

def ERASECHAR():
    return random.choice([ '\010',
        CSI + '1D' + CSI + '3~',
        CSI + 'D' + CSI + '3~',
    ])

def ERASELINE(iterm = False):
    choices = [
        '\015' + ' '*79 + '\015',
        '\015' + CSI + '2K', # Move left, kill whole line
        CSI + '1K' + CSI + '0K' + '\015', # kill left right then move left
        #'\033J' + '\033K' + '\015',
        '\015' + CSI + 'K',
    ]
    if iterm:
        choices.append('\010' * 80 + '\177' * 80)

    return random.choice(choices)

def ERASESCREEN():
    return INIT() + random.choice([
        # Clear screen
        CSI + '2J',
        CSI + '80T',
        " " + CSI + '1920b',
    ]) + random.choice([
        # Move to home position
        GOTO(1,1),
    ])


def STAT(s, x, y): #string at coords
    return random.choice([
        GOTO(x, y) + s,
        ])

def SAVECURSOR():
    return ESC + '7'

def RESTORECURSOR():
    return ESC + '8'

def ICONIFY():
    return CSI + '2t'

def DEICONIFY():
    return CSI + '1t'

def ALTSCREEN():
    return CSI + '?47h'

def EXITALT():
    return CSI + '?47l'

def FOCUSALERT():
    return CSI + '?1004h'

def NOFOCUSALERT():
    return CSI + '?1004l'

def NOSCROLL(): #Disable scrolling
    pass

def INIT():
    return FG("normal") + FG("green") + FG("brightgreen") + BG("black") + CURSOR("blinkingbar") + VISIBLE()

def QUERY():
    return CSI + '>0c'

TERMS = [
    [['FP Matches'], 'Name', 'Kill Command'],
    [['1;3201;0c'], 'Gnome-Terminal', ''],
    [['1;2c'], 'Terminal.App', ''],
    [['0;95;c'], 'iTerm', ''],
    [['0;271;0c'], 'xTerm', '']
]

level0password = 'Level 0 Is Really Easy'
level1password = 'G1V3M3TH3N3XTL3V3L'
level2password = 'HalfwayDone'
level3password = 'BobTheBuilder'
level4password = 'PINEY_FLATS_TN_USA'
flag = 'flag{WithYourCapabilitiesCombinedIAmCaptainTerminal}'

spinner='\\|/-'

with open("text1.png", "rb") as f:
    text1 = base64.b64encode(f.read())

with open("text2.six", "rb") as f:
    text2 = f.read()

with open("text3.tek", "rb") as f:
    text3 = f.read()


class ThreadedTCPRequestHandler(socketserver.BaseRequestHandler):
    def CHECKICON(self):
        self.send(ERASESCREEN())
        self.send("Feature check! There's a lot of cut-rate terminal emulators out there.\n")
        self.send("Let's see yours can really move.\n\n")
        self.send(ICONIFY())
        self.send("Press enter to continue.\n")
        #hide text:
        self.send(FG('hidden'))
        self.send(FG('black'))
        self.send(CURSOROFF())
        self.send(ESC + "P+q695465726d3250726f66696c65" + ST)
        self.send(ESC + "P+q6f6e6c797265706c79746f7468656e65787175657279" + ST)
        self.send(CSI + "11t")
        self.send(DEICONIFY())
        check = self.get()
        self.send(CURSORON())
        self.send(ERASELINE())
        self.send(FG('normal'))
        self.send(FG('normal48'))
        self.send(ERASESCREEN())

        match = itermre.search(check)
        if match:
            try:
                print(f"\t ({self.peer}) iTerm Profile: {bytes.fromhex(match.group()[1:]).decode('utf8')}")
                self.iterm = True
            except:
                pass
        if DEBUG:
            print(f"\t ({self.peer}) Received de-iconify response: {bytes(check, 'utf8').hex()}")
        return check.endswith("\033[2t\n")

    def wait(self, count=40, delay=0.1):
        for x in range(count):
            self.send(spinner[x % len(spinner)])
            time.sleep(delay)
            self.send(BACKSPACE(1))


    def CHECKWINDOW(self):
        self.send(ERASESCREEN())
        self.draw(
'''m     m #               m             "                    m    #
#  #  # # mm    mmm   mm#mm         mmm     mmm          mm#mm  # mm    mmm
" #"# # #"  #  "   #    #             #    #   "           #    #"  #  #"  #
 ## ##" #   #  m"""#    #             #     """m           #    #   #  #""""
 #   #  #   #  "mm"#    "mm         mm#mm  "mmm"           "mm  #   #  "#mm"




        mmmm    m mm   mmm   mmmm    mmm    m mm          mmm    mmm    m mm
        #" "#   #"  " #" "#  #" "#  #"  #   #"  "        #   "  #"  "   #"  "
        #   #   #     #   #  #   #  #""""   #             """m  #       #
        ##m#"   #     "#m#"  ##m#"  "#mm"   #            "mmm"  "#mm"   #
        #                    #
        "                    "

                                      "                    mmm
  mmm    mmm   m mm           mmm   mmm    mmmmm   mmm    "   #
 #"  #  #"  #  #"  #         #   "    #       m"  #"  #    m#"
 #""""  #""""  #   #          """m    #     m"    #""""    "
 "#mm"  "#mm"  #   #         "mmm"  mm#mm  #mmmm  "#mm"    #
(What is the proper screen size?)''')
        self.send(GOTO(24,30))
        self.send('Press enter to continue.')
        self.send(FG('normal'))
        self.send(FG('black'))
        self.send(BG('black'))
        self.send(FG('hidden'))
        self.send(INVISIBLE())
        self.send(QUERY())
        self.send(CSI + '18t')
        check = self.get()
        self.send(FG('normal'))
        self.send(BG('black'))
        self.send(FG('green'))
        self.send(FG('brightgreen'))
        self.send("Querying ")
        if not DEBUG:
            self.wait()
        self.send(ERASESCREEN())
        if DEBUG:
            print(f"\t ({self.peer}) Received windows response: {bytes(check, 'utf8').hex()}")
        if check.count(";") <= 1:
            self.wrong("Could not query your window size.\n\nPlease check your settings or try another terminal.\n\n")
            return False

        try:
            result = fpre.match(check)
            if result and result.group(1):
                if ';95' in result.group(1):
                    self.iterm = True
            if result and result.group(2):
                width=int(result.group(2).split(';')[-1])
                height=int(result.group(2).split(';')[1])
            else:
                self.wrong("Could not query your window size.\n\nPlease check your settings or try another terminal.\n\n")
                return False
        except:
            self.wrong("Couldn't query your window size.\n\nPlease check your settings or try another terminal.\n\n")
            return False


        if DEBUG:
            print(f"\t ({self.peer}) Width: {width}, height: {height}")

        self.send(ERASESCREEN())
        if width > 0 and height > 0:
            if (width, height) == (80, 24):
                self.sendandwait("Correct! The original size for a terminal. It's just right.")
            else:
                if width * height > 80*24:
                    self.wrong("Sorry, no, that is too big. ಠ_ಠ")
                    return
                else:
                    self.wrong("No, that's too small. Who even uses a terminal that little?")
                    return
        else:
            self.wrong(f'''What kind of cheap terminal are you even 
running over there? It can't even report its size!''')
            return False
        return True

    def draw(self, screen, kill=False):
        out = ''
        amap = []
        screen = screen.split('\n')
        max = 0
        for row in range(len(screen)):
            for col in range(len(screen[row])):
                amap.append([row + 1, col + 1, screen[row][col]])
        random.shuffle(amap)
        for coord in amap:
            out += STAT(self.chaff(coord[2], iterm=self.iterm, kill=kill), coord[1], coord[0])
        self.send(out)

    def sendandwait(self, msg):
        if isinstance(msg, str):
            msg = bytes(msg, 'utf8')
        self.request.sendall(msg)
        self.send("\n\nPress enter to continue.\n")
        check = self.get()

    def send(self, msg):
        if isinstance(msg, str):
            msg = bytes(msg, 'utf8')
        self.request.sendall(msg)

    def chaff(self, input, iterm=False, kill=False):
        # Intentionally not using the class iterm since I want to intentionally trigger 
        # that behavior after I grab both terminal fingerprint and obvious iterm specific stuff
        if not HARDER:
            return input
        output = ''
        for char in input:
            output += char
            choices = [
                #need more chaff, should be lots of good options here!
                CSI + '?' + str(random.randint(2222,9999)) + 'h',
                CSI + '?' + str(random.randint(2222,9999)) + 'l',
                ]
            if iterm:
                choices.append(OSC + '9;😈' + ST) 
                choices.append(OSC + '1337;AddHiddenAnnotation=😈' + ST)
                choices.append(OSC + '1337;RequestAttention=yes' + ST)
                choices.append(OSC + '1337;RequestAttention=fireworks' + ST)
            output += random.choice(choices)
            if kill:
                output += self.killsingle()
        return output

    def kill(self):
        choices = [
            f"{CSI}=2h",    #
            f"{CSI}4h",     #insert mode is weird
            f"{CSI}?1004h", #enable focus reporting / beep
            f"{CSI}2h",     #turn off keyboard
            #f"A{CSI}99999999999bB{CSI}99999999999bC{CSI}99999999999b", #oom terminal.app sometimes
            f"{CSI}100000000000T", #used to kill windows terminal
            f"{CSI}100000000000000000A", #used to kill gnome-terminal and putty
            f"{CSI}100000000000000000@", #used to kill gnome-terminal and putty
            f"{CSI}100000000000000000M", #used to kill gnome-terminal and putty
            CURSOROFF(),
        ]
        if self.iterm:
            choices.append(f"{CSI}5i") #unsafe on urxvt, spit out tons of paper
        for choice in choices:
            self.send(choice)

    def killsingle(self):
        if HARDER:
            choices = [
                f"{CSI}=2h",    #
                f"{CSI}?1004h", #enable focus reporting / beep
                f"{CSI}2h",     #turn off keyboard
            ]
            if self.iterm:
                choices.append(f"{CSI}5i") #unsafe on other terminals, spit out tons of paper
            return random.choice(choices)
        else:
            return ""

    def get(self):
        return str(self.request.recv(256), 'utf8')

    def wrong(self, msg = "I'm sorry, you are apparently not ready for this challenge."):
        self.send(ERASESCREEN())
        self.send(EXITALT())
        self.send(ERASESCREEN())
        self.send(msg)

    def level0(self):
        y = 8
        x = 19
        amap = []
        for i in range(len(level0password)):
            amap.append([i, level0password[i]])
        random.shuffle(amap)
        newpw = ''
        for e in amap:
            newpw += STAT(self.chaff(e[1]), x + e[0], y)

        self.send(f'''Welcome to the Terminal Velocity Server

Emoji? Back in my day we made do with only 7-bits for text and that was plenty.
None of these smiling poop faces. But wait, I hear you say -- there's all sorts
of new fancy attacks like text direction and homograph attacks so surely UTF is
more fun? Maybe, but do you really know what the simple terminal is capable of?

LEVEL 0 PASSWORD: Not the password.

With the right tool, this is trivial.''')
        self.send(newpw)
        self.send(STAT("Enter the password: ", 1, 12))
        level0answer = self.get().strip()
        if level0answer != level0password:
            self.wrong("\n\nThat is incorrect.\n")
            return False
        print(f'\t ({self.peer}) solved level 0.')
        return True

    def level1(self):
        self.send(ERASESCREEN())
        self.send(f'''{FG("black") + FG("hidden") + BG("black")}The password is: {self.chaff(level1password)}
{FG("normal") + FG("normal48") + BG("black") + FG("green") + FG("brightgreen")}LEVEL 1

Good! But that was pretty easy. This might be also.

Enter the password: ''')
        level1answer = self.get().strip()
        if level1answer != level1password:
            self.wrong("\n\nBZZZZZZZT!\n")
            return False
        print(f'\t ({self.peer}) solved level 1.')
        self.sendandwait("You got it!\n\n")
        return True


    def level2(self):
        self.send(ERASESCREEN())
        self.send(f'''{self.chaff(level2password, self.iterm)}{ERASELINE(self.iterm)}
LEVEL 2

Let's make sure you solved LEVEL 1 the intended way.

Enter the password: ''')
        level2answer = self.get().strip()
        if level2answer != level2password:
            self.wrong("\n\nGood job, that's--oh wait, no, I'm sorry, I mis-read. That's wrong.\n")
            return False
        self.sendandwait("\nGood job. See, only a bit harder. Careful, the next level starts to get mean.")
        print(f'\t ({self.peer}) solved level 2.')
        return True

    def level3(self):
        self.send(ERASESCREEN())
        self.kill()
        self.send("LEVEL 3\n")
        self.send(FG("normal") + BG("black") + FG("black"))
        self.draw(f'''

 ____        _   _____ _          ____        _ _     _
| __ )  ___ | |_|_   _| |__   ___| __ ) _   _(_) | __| | ___ _ __
|  _ \\ / _ \\| '_ \\| | | '_ \\ / _ \\  _ \\| | | | | |/ _` |/ _ \\ '__|
| |_) | (_) | |_) | | | | | |  __/ |_) | |_| | | | (_| |  __/ |
|____/ \\___/|_.__/|_| |_| |_|\\___|____/ \\__,_|_|_|\\__,_|\\___|_|


The above special font is important to get right. This text is only important
to make sure we get enough chaff sent to cause maximum carnage. 
''', kill=True)
        self.send(GOTO(2, 15))

        #Not sure about this one, might delete these
        if EXTRAHARD:
            self.send("Don't blink or you'll miss it.")
            self.send(ERASESCREEN())
            self.send("LEVEL 3\n")
            self.send(GOTO(2, 15))
        #Not sure about this one, might delete these

        self.send(FG("normal") + BG("black") + FG("green") + FG("brightgreen"))
        #Recover hidden drawing/color after breaking terminals?
        self.send("\n\nEnter the password: ")
        level3answer = self.get().strip()
        if level3answer != level3password:
            self.wrong("\n\nOh no, and after making it so far... Incorrect.\n")
            return False
        print(f'\t ({self.peer}) solved level 3.')
        self.sendandwait("That's right! You are getting good. One last one.")
        return True


    def level4(self):
        self.sendandwait(f'''

Fine. Sure, I mean, you solved that. Whatever. No big deal.

I'm not offended. I had to walk uphill both ways in the snow and enter ascii
with a telegraph machine. You kids think UTF8 is fancy, you should see EBCDIC!

It's fine. Really. You want some fancy new fangled hotness? PLUS some old
stuff? Ok. You must combine these three images. There are three real terminal
emulators that will each display one of these. Good luck.

''')

        self.send("\nFILE1:\n")
        self.send(f"{OSC}1337;File=inline=1;size=24998:")
        self.send(text1)
        self.send(BEL)
        self.send("\nFILE2:\n")
        self.send(text2)
        self.send("\nFILE3:\n")
        self.send(text3)

        self.send("\n\nEnter the password: ")
        level4answer = self.get().strip()
        if level4answer != level4password:
            self.wrong("Oh no! You were so close, this is the last stage.")
            return False
        print(f'\t ({self.peer}) solved level 4.')
        self.sendandwait("Way to go!")
        return True

    def handle(self):
        try:
            self.iterm = False
            self.peer = self.request.getpeername()[0]
            self.request.settimeout(30)
            if DEBUG:
                print(f'Connection from {self.peer}')
            random.seed(time.time() + random.randint(0, 2**32)) #bad random, but don't really care, it's good enough, just want it different per thread
            self.send(EXITALT())
            self.send(ALTSCREEN())
            self.send(INIT())

            self.send(ERASESCREEN())

            if not self.level0():
                return

            if not self.CHECKWINDOW():
                return

            if not self.level1():
                return

            if not self.CHECKICON():
                self.wrong("Sorry, you might want to figure out what a more fully featured (and permissive) terminal would do here.")
                return
            self.sendandwait("Congratulations! You've got a pretty fancy terminal there!")

            if not self.level2():
                return

            if not self.level3():
                return

            self.send(ERASESCREEN())

            if not self.level4():
                return
            self.send(EXITALT())
            self.send(ERASESCREEN())
            self.send("You made it! Congratulations. Your flag is: \n\n")
            self.send(flag)

        except socket.timeout:
            self.send(ERASESCREEN())
            self.send(EXITALT())
            self.send(ERASESCREEN())
            self.send('\n\nTimeout, closing connection.\n')
            pass
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass
            else:
                raise


class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass


def interact():
    try:
        #Better testing if available
        from IPython import embed
        embed(colors='neutral')
    except:
        import code
        code.InteractiveConsole(locals=globals()).interact()

def client(ip, port, message):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.connect((ip, port))
        sock.sendall(bytes(message, 'ascii'))
        response = str(sock.recv(1024), 'ascii')
        print('Received: {}'.format(response))

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'test':
        interact()
        sys.exit(0)
    # Port 0 means to select an arbitrary unused port
    HOST, PORT = '0.0.0.0', 3535
    ThreadedTCPServer.allow_reuse_address = True
    server = ThreadedTCPServer((HOST, PORT), ThreadedTCPRequestHandler)
    server.serve_forever()
