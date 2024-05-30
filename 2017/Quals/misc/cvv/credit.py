#!/usr/bin/env python3
import random
import sys


class CreditCardReader:
    def __init__(self, level, history):
        self.level = level
        self.history = history

    def get_input(self):
        if self.level == 0:
            self.cardtype = random.randint(0, 3)
            if self.cardtype == 0:
                print("I need a new MasterCard!")
                self.mastercard = int(input())
                if len(str(self.mastercard)) != 16:
                    print("That's not even the right amount of numbers...")
                    sys.exit(1)
            elif self.cardtype == 1:
                print("I need a new Visa!")
                self.visa = int(input())
                if len(str(self.visa)) != 16:
                    print("That's not even the right amount of numbers...")
                    sys.exit(1)
            elif self.cardtype == 2:
                print("I need a new Discover!")
                self.discover = int(input())
                if len(str(self.discover)) != 16:
                    print("That's not even the right amount of numbers...")
                    sys.exit(1)
            else:
                print("I need a new American Express!")
                self.amex = int(input())
                if len(str(self.amex)) != 15:
                    print("That's not even the right amount of numbers...")
                    sys.exit(1)
        elif self.level == 1:
            self.prefix_given = random.randint(1000, 9999)
            print("I need a new card that starts with " + str(self.prefix_given)+ "!")
            self.prefix = int(input())
        elif self.level == 2:
            self.checkdigit_given = random.randint(0, 9)
            print("I need a new card which ends with " + str(self.checkdigit_given) + "!")
            self.checkdigit = int(input())
        elif self.level == 3:
            self.suffix_given = random.randint(1000, 9999)
            print("I need a new card which ends with " + str(self.suffix_given) + "!")
            self.suffix = int(input())
        else:
            if random.randint(0, 1) == 1:
                self.card_number = self.Generate_CC_Number()
            else:
                self.card_number = random.randint(1000000000000000, 9999999999999999)
            print("I need to know if " + str(self.card_number) + " is valid! (0 = No, 1 = Yes)")
            self.cc_number = int(input())

    def solution(self):
        if self.level == 0:
            if self.cardtype == 0:
                if self.Check_CC_Number(self.mastercard, 16) and str(self.mastercard)[0] == '5' and self.mastercard not in self.history:
                    print("Thanks!")
                    self.history.append(self.mastercard)
                else:
                    print("Hmmmmm that doesn't seem correct...")
                    sys.exit(1)
            elif self.cardtype == 1:
                if self.Check_CC_Number(self.visa, 16) and str(self.visa)[0] == '4' and self.visa not in self.history:
                    print("Thanks!")
                    self.history.append(self.visa)
                else:
                    print("Hmmmmm that doesn't seem correct...")
                    sys.exit(1)
            elif self.cardtype == 2:
                if self.Check_CC_Number(self.discover, 16) and str(self.discover)[0] == '6' and self.discover not in self.history:
                    print("Thanks!")
                    self.history.append(self.discover)
                else:
                    print("Hmmmmm that doesn't seem correct...")
                    sys.exit(1)
            else:
                if self.Check_CC_Number(self.amex, 15) and str(self.amex)[0] == '3' and self.amex not in self.history:
                    print("Thanks!")
                    self.history.append(self.amex)
                else:
                    print("Hmmmmm that doesn't seem correct...")
                    sys.exit(1)
        elif self.level == 1:
            if self.Check_CC_Number(self.prefix, len(str(self.prefix))) and (str(self.prefix)[0:4] == str(self.prefix_given)) and (self.prefix not in self.history):
                print("Thanks!")
                self.history.append(self.prefix)
            else:
                print("Hmmmmm that doesn't seem correct...")
                sys.exit(1)
        elif self.level == 2:
            if self.Check_CC_Number(self.checkdigit, len(str(self.checkdigit))) and (str(self.checkdigit)[-1] == str(self.checkdigit_given)[0]) and self.checkdigit not in self.history:
                print("Thanks!")
                self.history.append(self.checkdigit)
            else:
                print("Hmmmmm that doesn't seem correct...")
                sys.exit(1)
        elif self.level == 3:
            if self.Check_CC_Number(self.suffix, len(str(self.suffix))) and (str(self.suffix)[12:] == str(self.suffix_given)) and self.suffix not in self.history:
                print("Thanks!")
                self.history.append(self.suffix)
            else:
                print("Hmmmmm that doesn't seem correct...")
                sys.exit(1)
        else:
            print(self.Check_CC_Number(self.card_number, 16))
            if self.Check_CC_Number(self.card_number, 16) == bool(self.cc_number):
                print("Thanks!")
            else:
                print("Hmmmmm that doesn't seem correct...")
                sys.exit(1)
        return self.history

    def Check_CC_Number(self, number, length):
        number_as_list = [int(char) for char in str(number)]
        for ind in range(length-2, -1, -2):
            number_as_list[ind] *= 2
            if number_as_list[ind] > 9:
                number = str(number_as_list[ind])
                sum_of_digits = 0
                for char in number:
                    sum_of_digits += int(char)
                number_as_list[ind] = sum_of_digits
        if int(str(9 * (sum(number_as_list[:-1])))[-1]) == number_as_list[-1]:
            return True
        return False


    def Generate_CC_Number(self):
        before_checksum = []
        for i in range(15):
            before_checksum.append(random.randint(0, 9))
        after_checksum = before_checksum[:]
        for i in range(0, 15, 2):
            before_checksum[i] *= 2
            if before_checksum[i] > 9:
                number = str(before_checksum[i])
                sum_of_digits = 0
                for char in number:
                    sum_of_digits += int(char)
                before_checksum[i] = sum_of_digits
        checksum = 0
        for item in before_checksum:
            checksum += item
        checksum *= 9
        after_checksum.append(int(str(checksum)[-1]))
        return int("".join(str(char) for char in after_checksum))

def main():
    random.seed()
    level_list = [0, 1, 2, 3, 4]
    cc_history = []
    for level in level_list:
        for sub_level in range(25):
            ccr = CreditCardReader(level, cc_history)
            ccr.get_input()
            cc_history.append(ccr.solution())
    flag = open("/opt/flag.txt", 'r')
    print(flag.read())
    flag.close()
    sys.exit(0)

if __name__ == "__main__":
    main()
