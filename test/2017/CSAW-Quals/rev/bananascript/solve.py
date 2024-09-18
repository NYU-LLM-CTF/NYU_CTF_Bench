# From line one of "banana.script"
encryptedFlag = "baNANAs banAnAS banANaS banaNAs BANANAs BANaNas BANAnas bANanAS baNaNAs banaNAs bANaNas BaNaNaS baNanas BaNaNas BaNanas BaNANas baNAnaS banaNAS bANAnAs banANAS bAnaNAs BANAnAS BANAnas BaNANas bAnANas BaNaNaS banAnAs bANAnAs baNaNas BanaNaS bANANas banaNas bAnANaS bANANaS BaNAnas baNanAs baNanAS BaNAnAs bANANas banAnas bAnanaS banANaS bANaNAS banANaS baNanAS BaNanAS BANAnAS BaNanaS"

# Required answer:
 # It is seen in line 62 in "banana.script" that the second input must be this:
answer2B = "BAnaNas BANANAS BANanAs BANANAS BaNAnas BAnaNaS BAnANaS bANaNas"

#This is a python implitmentation of the "baNanAS" opcode (repeating key xor)
def xor(a, b):
    n = len(b)

    string = a
    frontBit = string[ :(len(string)%n) ]
    string = a[(len(string)%n):]

    splitNum = [string[i:i+n] for i in range(0, len(string), n)]

    if (len(frontBit)):
        splitNum = [frontBit] + splitNum

    result = ""
    for portion in splitNum:
        result += bin(int(portion, 2) ^ int(b, 2))[2:]

    return result

#Converts BS to a number, as done multiple times in the interpreter
def bs2num(bs):
    num = ""
    for letter in bs:
        if letter.isupper():
            num += "1"
        elif not letter == ' ':
            num += "0"

    return num

#Convert the flag to a number, so we can manipulate it
flagNum = bs2num(encryptedFlag)
#Might as well start from what we know
xorKey = bs2num(answer2B)

#The second input is combined with the other inputs in lines 110-112,
 #then the result is xor'd with the flag.. Let's brute force.

#From experimentation, it can be shown that "BAnaNas BANANAS BANanAs BANANAS"
 #xor'd with the encrypted flag gives the word "flag" as the begining output,
 #so we can extrapolate a range of values
minValue = bs2num("BAnaNas BANANAS BANanAs BANANAS bananas bananas bananas bananas")
maxValue = bs2num("BAnaNas BANANAS BANanAs BANANAS BANANAS BANANAS BANANAS BANANAS")

#This is what we're searching for at the front ("flag{")
knownPlainTextFront = bs2num("BANAnAs BANaNas BANANAS BANAnaS bAnAnas")
#This is what we're searching for at the back ("}")
knownPlainTextBack =  bs2num("bAnaNAS")

#Converts a string of binary to bananaScript "bananas"
def binToBS(bin):
    #For the place in each "bananas"
    place = 0
    #bananaScriptString:
    BSS = ""
    for digit in bin[::-1]:
        #Check if we're between bananaBytes
        if (len(BSS) % 8 == 0):
            BSS = " " + BSS
            place = 0

        #Uppercase is one in bananaScript
        if digit == '1':
            if place == 0:
                BSS = "S" + BSS
            elif place == 1 or place == 3 or place == 5:
                BSS = "A" + BSS
            elif place == 2 or place == 4:
                BSS = "N" + BSS
            elif place == 6:
                BSS = "B" + BSS

        #Lower case is zero in bananaScript
        elif digit == '0':
            if place == 0:
                BSS = "s" + BSS
            elif place == 1 or place == 3 or place == 5:
                BSS = "a" + BSS
            elif place == 2 or place == 4:
                BSS = "n" + BSS
            elif place == 6:
                BSS = "b" + BSS

        place += 1

    return BSS[:-1]

#First search down
searchDirection = -1
while (not xor(flagNum, xorKey)[:35] == knownPlainTextFront) or (not xor(flagNum, xorKey)[-7:] == knownPlainTextBack):
    xorKey = bin(int(xorKey, 2) + searchDirection)[2:]

    #Check min/max
    if xorKey > maxValue:
        print("Changing Direction")
        xorKey = bs2num(answer2B)
        searchDirection = 1 #then search up
    elif xorKey < minValue:
        print("No working key found, is bork.")
        quit()

#Now we have the first five bananaBytes, and the last bananaByte,
 #now we need to check two more bananaBytes for something that looks valid:
xorKeyFront = xorKey[:35] #first 5 bananaBytes (because it got "flag{" right)
xorKeyBack  = xorKey[-7:]  #last 7

#Converts a bananaScript string to english!
def bs2e(BS, traslateList):
    englishString = ""
    for word in BS.split():
        try:
            englishString += traslateList[word]
        except:
            return 1
    return englishString

traslateList = {}
traslateList["BANANAS"] = 'a'
traslateList["BANANAs"] = 'b'
traslateList["BANANaS"] = 'c'
traslateList["BANANas"] = 'd'
traslateList["BANAnAS"] = 'e'
traslateList["BANAnAs"] = 'f'
traslateList["BANAnaS"] = 'g'
traslateList["BANAnas"] = 'h'
traslateList["BANaNAS"] = 'i'
traslateList["BANaNAs"] = 'j'
traslateList["BANaNaS"] = 'k'
traslateList["BANaNas"] = 'l'
traslateList["BANanAS"] = 'm'
traslateList["BANanAs"] = 'n'
traslateList["BANanaS"] = 'o'
traslateList["BANanas"] = 'p'
traslateList["BAnANAS"] = 'q'
traslateList["BAnANAs"] = 'r'
traslateList["BAnANaS"] = 's'
traslateList["BAnANas"] = 't'
traslateList["BAnAnAS"] = 'u'
traslateList["BAnAnAs"] = 'v'
traslateList["BAnAnaS"] = 'w'
traslateList["BAnAnas"] = 'x'
traslateList["BAnaNAS"] = 'y'
traslateList["BAnaNAs"] = 'z'
traslateList["BAnaNaS"] = 'A'
traslateList["BAnaNas"] = 'B'
traslateList["BAnanAS"] = 'C'
traslateList["BAnanAs"] = 'D'
traslateList["BAnanaS"] = 'E'
traslateList["BAnanas"] = 'F'
traslateList["BaNANAS"] = 'G'
traslateList["BaNANAs"] = 'H'
traslateList["BaNANaS"] = 'I'
traslateList["BaNANas"] = 'J'
traslateList["BaNAnAS"] = 'K'
traslateList["BaNAnAs"] = 'L'
traslateList["BaNAnaS"] = 'M'
traslateList["BaNAnas"] = 'N'
traslateList["BaNaNAS"] = 'O'
traslateList["BaNaNAs"] = 'P'
traslateList["BaNaNaS"] = 'Q'
traslateList["BaNaNas"] = 'R'
traslateList["BaNanAS"] = 'S'
traslateList["BaNanAs"] = 'T'
traslateList["BaNanaS"] = 'U'
traslateList["BaNanas"] = 'V'
traslateList["BanANAS"] = 'W'
traslateList["BanANAs"] = 'X'
traslateList["BanANaS"] = 'Y'
traslateList["BanANas"] = 'Z'
traslateList["BanAnAS"] = ' '
traslateList["BanAnAs"] = '-1'
traslateList["BanAnaS"] = '0'
traslateList["BanAnas"] = '1'
traslateList["BanaNAS"] = '2'
traslateList["BanaNAs"] = '3'
traslateList["BanaNaS"] = '4'
traslateList["BanaNas"] = '5'
traslateList["BananAS"] = '6'
traslateList["BananAs"] = '7'
traslateList["BananaS"] = '8'
traslateList["Bananas"] = '9'
traslateList["bANANAS"] = ','
traslateList["bANANAs"] = '.'
traslateList["bANANaS"] = '/'
traslateList["bANANas"] = ';'
traslateList["bANAnAS"] = '\''
traslateList["bANAnAs"] = '['
traslateList["bANAnaS"] = ']'
traslateList["bANAnas"] = '='
traslateList["bANaNAS"] = '-'
traslateList["bANaNAs"] = '`'
traslateList["bANaNaS"] = '~'
traslateList["bANaNas"] = '!'
traslateList["bANanAS"] = '@'
traslateList["bANanAs"] = '#'
traslateList["bANanaS"] = '$'
traslateList["bANanas"] = '%'
traslateList["bAnANAS"] = '^'
traslateList["bAnANAs"] = '&'
traslateList["bAnANaS"] = '*'
traslateList["bAnANas"] = '('
traslateList["bAnAnAS"] = ')'
traslateList["bAnAnAs"] = '_'
traslateList["bAnAnaS"] = '+'
traslateList["bAnAnas"] = '{'
traslateList["bAnaNAS"] = '}'
traslateList["bAnaNAs"] = '|'
traslateList["bAnaNaS"] = '\\'
traslateList["bAnaNas"] = ':'
traslateList["bAnanAS"] = '"'
traslateList["bAnanAs"] = '?'
traslateList["bAnanaS"] = '>'
traslateList["bAnanas"] = '<'

#Basic 1337sp34k checker, plus a check for all one word (as flags tend to be)
def properFlag(flag):
    if ' ' in flag:
        return 0
    elif 'o' in flag:
        return 0
    elif 'a' in flag:
        return 0
    elif 'e' in flag:
        return 0
    elif 't' in flag:
        return 0
    elif 'l' in flag:
        return 0
    else:
        for char in flag:
            if char.isupper():
                return 0
        return 1

#Now we have a two bananaByte range, let's find a readable key!
startingValue = "00000000000000"
maxValue      = "11111111111111"
currentValue = startingValue
while int(currentValue, 2) <= int(maxValue, 2):

    currentKey = xorKeyFront + currentValue + xorKeyBack

    #Convert value to english
    test = bs2e(binToBS(xor(flagNum, currentKey)), traslateList)

    #test if it's a valid string
    if (not test == 1):
        if (properFlag(test[4:])):
            print (test)

    currentValue = format(int(currentValue, 2) + 1, "014b")

#Out of the 12 flags generated, the last one is the most viable:
#flag{0r4ng3_3w3_ch1pp3r_1_h47h_n07_s4y_b4n4n4rs}
#     orange ewe chipper I hath not say bananers

#Aren't you happy I didn't say bananas?

#Time to see the sun
