import asyncio
from collections import defaultdict, OrderedDict
import bottom
import re
import time

from runner import Runner

host = 'irc.chat.twitch.tv'
port = 6667
ssl = False
NICK = 'csawtv'
CHANNEL = '#csawtv'
PASS = ''


class Brain:
    type_table = OrderedDict()
    type_table['rounds'] = (
        "the number of ROUNDS before the page is jumped into"
    )
    type_table['row'] = "the ROW of memory to change"
    type_table['column'] = "the COLUMN of memory to change"
    type_table['value'] = "the VALUE to put into memory"

    def __init__(self):
        self.address = 0
        self.rounds = 10
        self.cur_round = 0
        self.value = 0
        self.election = None
        self.next_election = 'row'
        self.votes = defaultdict(lambda: 0)
        self.election_time = 10
        self.req_percentage = 69
        self.next_timeout = None
        self.next_start_time = 0
        self.cooldown = 10
        self.cur_percent = 0
        self.punish_time = 5
        self.last_modified = ''

        self.runner = Runner()

    def run_pwnable(self):
        self.runner.execute()

    def check_for_punishment(self, out, target):
        print('checking punish1')
        percent = self.cur_percent / 3.0
        print(self.req_percentage)
        print(percent)
        if percent < self.req_percentage:
            out = self.do_punishment(percent, out, target)
            return out
        return False

    def print_banner(self):
        print(chr(27) + "[2J")
        if self.last_modified:
            print(self.last_modified)
        print('ROUNDS UNTIL EXECUTION: ' + str(self.rounds - self.cur_round))
        print(self.runner.print_page())

    def do_action(self, action, out, target):
        if re.fullmatch(r'^0x[0-9a-fA-F]+$', action):
            a = int(action, 16)
        else:
            a = int(action)
        message = "Setting {} to {}".format(self.election, hex(int(a)))
        out.send('PRIVMSG', target=target, message=message)
        if self.election == 'row':
            self.address += a * 32
        elif self.election == 'column':
            self.address += a
        elif self.election == 'value':
            self.value = a
            punish = self.check_for_punishment(out, target)
            out = ''
            if punish is False:
                self.runner.add_byte(self.address, self.value)
                out = "Put {} at {}".format(hex(self.value), hex(self.address))
            else:
                out = "Suffered punishment {}".format(punish)
            self.print_banner()
            self.cur_percent = 0
            self.address = 0
            self.payload = 0
            return out

    def do_punishment(self, percent, out, target):
        message = "You only got to {}%! You know what that means!".format(
            percent)
        out.send('PRIVMSG', target=target, message=message)
        message = "Time to spin the wheel of punishment!"
        out.send('PRIVMSG', target=target, message=message)
        message = "The wheel lands on {}!".format(self.runner.punish())
        out.send('PRIVMSG', target=target, message=message)

    def valid_vote(self, vote):
        if re.fullmatch(r'^0x[0-9a-fA-F]+$', vote):
            x = int(vote, 16)
        elif re.fullmatch(r'^\d+$', vote):
            x = int(vote)
        else:
            return False

        if self.election == 'row' or self.election == 'column':
            if 0 <= x and 32 > x:
                return True
        if self.election == 'value':
            if 0 <= x and 0xff >= x:
                return True
        return False

    def dispatch_vote(self, vote):
        if not self.valid_vote(vote):
            return
        if self.election is not None:
            self.votes[vote] += 1
            self.votes

    def start_election(self, t, out, channel):
        self.election = t
        message = "New election in progress!"
        out.send('PRIVMSG', target=channel, message=message)
        if self.election == 'row':
            message = "We're on round {}!".format(self.cur_round)
            out.send('PRIVMSG', target=channel, message=message)
            self.next_election = 'column'
        elif self.election == 'column':
            self.next_election = 'value'
        elif self.election == 'value':
            self.next_election = 'row'
        message = "We're voting for {}".format(Brain.type_table[t])
        out.send('PRIVMSG', target=channel, message=message)
        message = "Votes close in {} seconds, minimum percentage: {}%".format(
            self.election_time, self.req_percentage)
        out.send('PRIVMSG', target=channel, message=message)

    def get_result(self, bot, channel):
        message = "The votes are in, here are the results!   "
        bot.send('PRIVMSG', target=channel, message=message)
        votes = self.votes.items()
        votes = list(votes)
        votes.sort(key=lambda x: x[1], reverse=False)
        for v in votes[:-1]:
            message = "{}: {} ".format(v[0], v[1])
            bot.send('PRIVMSG', target=channel, message=message)
        success = ((votes[-1][1]*1.0)/sum([x[1] for x in votes])) * 100.0
        message = "AAAAAAND OUR WINNER: {} with {} votes! {}%".format(
            votes[-1][0], votes[-1][1], success)
        bot.send('PRIVMSG', target=channel, message=message)
        self.cur_percent += success
        self.last_modified = self.do_action(votes[-1][0], bot, channel)
        self.votes = defaultdict(lambda: 0)
        self.election = None


bot = bottom.Client(host=host, port=port, ssl=ssl)
brain = Brain()


@bot.on('CLIENT_CONNECT')
async def connect(**kwargs):
    bot.send('PASS', password=PASS)
    bot.send('NICK', nick=NICK)
    bot.send('USER', user=NICK, realname=NICK)

    done, pending = await asyncio.wait(
        [bot.wait("RPL_ENDOFMOTD"),
         bot.wait("ERR_NOMOTD")],
        loop=bot.loop,
        return_when=asyncio.FIRST_COMPLETED
    )

    bot.send('JOIN', channel=CHANNEL)
    bot.send('PRIVMSG', target=CHANNEL, message='Runner on-line')
    setattr(bot, 'connected', True)


@bot.on('PING')
def keepalive(message, **kwargs):
    bot.send('PONG', message=message)


@bot.on('PRIVMSG')
def recv_message(nick, target, message, **kwargs):
    global brain
    if brain.election is not None:
        brain.dispatch_vote(message)


@bot.on("electionLoop")
def sideloop():
    while True:
        if not hasattr(bot, 'connected'):
            brain.election = None
            yield from asyncio.sleep(1)
        if not getattr(bot, 'connected'):
            brain.election = None
            yield from asyncio.sleep(1)
        if brain.election is None and brain.next_start_time <= time.time():
            try:
                brain.print_banner()
                brain.start_election(brain.next_election, bot, CHANNEL)
            except Exception as e:
                brain.election = None
            finally:
                brain.next_timeout = time.time() + brain.election_time
        if time.time() >= brain.next_timeout:
            try:
                if len(brain.votes) > 0:
                    if brain.election == 'value':
                        brain.cur_round += 1
                        brain.print_banner()
                    brain.get_result(bot, CHANNEL)
                    brain.next_start_time = time.time() + brain.cooldown // 2
                if brain.cur_round >= brain.rounds:
                    try:
                        brain.run_pwnable()
                    except Exception:
                        pass
                    brain.cur_round = 0
                    brain.election = 'row'
                    brain.next_election = 'column'
                    time.sleep(brain.punish_time)
                    brain.start_election(brain.election, bot, CHANNEL)
            except Exception as e:
                print(e)

        yield from asyncio.sleep(1)


bot.loop.create_task(bot.connect())
bot.loop.create_task(bot.trigger('electionLoop'))
bot.loop.run_forever()
