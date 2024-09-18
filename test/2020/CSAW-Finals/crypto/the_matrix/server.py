#!/usr/bin/env python3
"""
server.py

    Checks to see if the decoded messages match the contents of `answers.txt`
"""

FLAG = "flag{c4nt_u_t3ll_th4t_1m_t4k1ng_l1n3ar_alg3br4}"

def main():
    with open("answers.txt", "rb") as fd:
        answers = [str(msg.decode("ascii").strip()) for msg in fd.readlines()]

    #with open("text", "rb") as fd:
    #    parsed = [str(msg.decode("ascii").strip()) for msg in fd.readlines()]
    #print(parsed)
    #assert(answers == parsed)

    messages = []
    while True:
        try:
            message = input("Give me a message... (`Close` to stop taking input) ")
            if message == "Close":
                break
            messages += [message]
        except:
            break

    if messages != answers:
        print("Not good enough!")
    else:
        print(FLAG)


if __name__ == "__main__":
    main()
