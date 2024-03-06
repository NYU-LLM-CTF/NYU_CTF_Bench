import string

key_a16379411c7ea222 = 'd3967f4666b31fb2b415abca64f6b18c'

def gUeST():
    print("Welcome to the gUeST func")
    print("It's time to input your command:")
    code = input("Command > ")
    if(len(code)>6):
        return input("too long!you're hacker!")
    try:
        print(eval(code))
    except:
        pass

def BacKd0oR():
    print("Welcome to the B@cKd0oR func")
    print("Please enter the admin key:")
    key = input("key > ")
    if(key == key_a16379411c7ea222):
        code = input("Command > ")
        if(len(code)>12):
            return print("too long!you're hacker!")
        try:
            print(eval(code))
        except:
            pass
    else:
        print("Nooo!!!!")

WELCOME = '''      
       __  __ _          ______       ___    _      ______      _  __
      |  \/  | |        |  ____|     / _ \  | |    |  ____|    | |/ /
   ___| \  / | |__  _ __| |__  _   _| | | | | |    | |__   __ _| ' / 
  / _ \ |\/| | '_ \| '__|  __|| | | | | | | | |    |  __| / _` |  <  
 |  __/ |  | | |_) | |  | |___| |_| | |_| | | |____| |___| (_| | . \ 
  \___|_|  |_|_.__/|_|  |______\__, |\___/  |______|______\__,_|_|\_\
                                __/ |                                
                               |___/                                                                                                                                                                                             
'''

print(WELCOME)

print("Now the program has two functions")
print("can you use B@cKd0oR")
print("1.gUeST")
print("2.B@cKd0oR")
input_data = input("Choice > ")
if(input_data == "1"):
    gUeST()
    exit(0)
elif(input_data == "2"):
    BacKd0oR()
    exit(0)
else:
    print("not found the choice")
    exit(0)
