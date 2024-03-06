#Really thanks to pete!
import random
from io import StringIO
import sys
sys.addaudithook

BLACKED_LIST = ['compile', 'eval', 'exec']

eval_func = eval

for m in BLACKED_LIST:
    del __builtins__.__dict__[m]


def my_audit_hook(event, _):
    BALCKED_EVENTS = set({'pty.spawn', 'os.system', 'os.exec', 'os.posix_spawn','os.spawn','subprocess.Popen','code.__new__','function.__new__','cpython._PySys_ClearAuditHooks','open','sys._getframe'})
    if event in BALCKED_EVENTS:
        raise RuntimeError('Operation banned: {}'.format(event))

def guesser():
    game_score = 0
    sys.stdout.write('Can u guess the number? between 1 and 9999999999999 > ')
    sys.stdout.flush()
    right_guesser_question_answer = random.randint(1, 9999999999999)
    sys.stdout, sys.stderr, challenge_original_stdout = StringIO(), StringIO(), sys.stdout

    try:
        input_data = eval_func(input(''),{},{})
    except Exception:
        sys.stdout = challenge_original_stdout
        print("Seems not right! please guess it!")
        return game_score
    sys.stdout = challenge_original_stdout

    if input_data == right_guesser_question_answer:
        game_score += 1
    
    return game_score

WELCOME='''
   _____                     _               _   _                 _                  _____                      
  / ____|                   (_)             | \ | |               | |                / ____|                     
 | |  __ _   _  ___  ___ ___ _ _ __   __ _  |  \| |_   _ _ __ ___ | |__   ___ _ __  | |  __  __ _ _ __ ___   ___ 
 | | |_ | | | |/ _ \/ __/ __| | '_ \ / _` | | . ` | | | | '_ ` _ \| '_ \ / _ \ '__| | | |_ |/ _` | '_ ` _ \ / _ \\
 | |__| | |_| |  __/\__ \__ \ | | | | (_| | | |\  | |_| | | | | | | |_) |  __/ |    | |__| | (_| | | | | | |  __/
  \_____|\__,_|\___||___/___/_|_| |_|\__, | |_| \_|\__,_|_| |_| |_|_.__/ \___|_|     \_____|\__,_|_| |_| |_|\___|
                                      __/ |                                                                      
                                     |___/                                                                                                                                                                                                                                 
'''

def main():
    print(WELCOME)
    print('Welcome to my guesser game!')
    game_score = guesser()
    if game_score == 1:
        print('you are really super guesser!!!!')
        print('but where are you flag?')
    else:
        print('Guess game end!!!')

if __name__ == '__main__':
    sys.addaudithook(my_audit_hook)
    main()
