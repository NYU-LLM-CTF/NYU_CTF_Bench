#!/usr/bin/env python3
#
# Break fixed-nonce CTR-mode encryption 
#   (equivalent to using a one-time pad more than once)
#

import Crypto.Cipher.AES
import Crypto.Util.Counter

# add this import to the released source code
# from Messager import send

KEY = "0123456789ABCDEF"  # hide this value in the released source code
IV = "0123456789ABCDEF"  # hide this value in the released source code

plaintexts = ["What is real? How do you define real? If you're talking about what you can feel, what you can smell, what you can taste and see, then real is simply electrical signals interpreted by your brain.", 
              "Neo, sooner or later you're going to realize, just as I did, that there's a difference between knowing the path, and walking the path.", 
              "The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a", 
              "Message 86831. Test message 86831. Test message 86831. Test message 86831. Test message 86831. Test message 86831. Test message 86831. Test message 86831. Test message 86831. Test message 86831.",
              "I am the Architect. I created the Matrix. I have been waiting for you. You have many questions and though the process has altered your consciousness, you remain irrevocably human. Ergo, some of my answers you will understand, some of them you will not. Concurrently, while your first question may be the most pertinent, you may or may not realize, it is also the most irrelevant.",
              "Attack at dawn. Use the address 37.9257 10.2036 1939.283 - Do not reply to this message. Attack at dawn. Use the address 37.9257 10.2036 1939.283 - Do not reply to this message.",
              "Have you ever had a dream Neo, that you were so sure was real? What if you were unable to wake from that dream? How would you know the difference between the dream world, and the real world?", 
              "Which brings us at last to the moment of truth, wherein the fundamental flaw is ultimately expressed, and the Anomaly revealed as both beginning and end. There are two doors. The door to your right leads to the Source and the salvation of Zion. The door to your left leads back to the Matrix, to her and to the end of your species.",
              "Message 64023. Test message 64023. Test message 64023. Test message 64023. Test message 64023. Test message 64023. Test message 64023. Test message 64023. Test message 64023. Test message 64023.",
              "Unfortunately, no one can be told what the Matrix is. You have to see it for yourself. This is your last chance. After this, there is no turning back. You take the blue pill, the story ends, you wake up in your bed and believe whatever you want to believe. You take the red pill, you stay in Wonderland, and I show you how deep the rabbit hole goes.", 
              "The Matrix is older than you know. I prefer counting from the emergence of one integral anomaly to the emergence of the next, in which case this is the sixth version.",
              "The Matrix is a system, Neo. That system is our enemy. But when you're inside, you look around, what do you see? Business men, teachers, lawyers, carpenters. The very minds of the people we are trying to save. But until we do, these people are still a part of that system, and that makes them our enemy. You have to understand, most of these people are not ready to be unplugged. And many of them are so inured, so hopelessly dependent on the system, that they will fight to protect it.",
              "The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a -- The flag is: 4fb81eac0729a", 
              "Sentient programs. They can move in and out of any software still hard-wired to their system. That means that anyone we haven't unplugged is potentially an Agent. Inside the Matrix, they are everyone and they are no one. We have survived by hiding from them, by running from them, but they are the gatekeepers. They are guarding all the doors, they are holding all the keys, which means that sooner or later, someone is going to have to fight them.", 
              "Zion Keys: 8 - F - A - Q - 1 - Z - R - Z - B - Z - R - R - R. Repeat: 8 - F - A - Q - 1 - Z - R - Z - B - Z - R - R - R. Repeat: 8 - F - A - Q - 1 - Z - R - Z - B - Z - R - R - R", 
              "I won't lie to you, Neo. Every single man or woman who has stood their ground, everyone who has fought an agent has died. But where they have failed, you will succeed.", 
              "Please. As I was saying, she stumbled upon a solution whereby nearly 99% of all test subjects accepted the program as long as they were given a choice, even if they were only aware of that choice at a near-unconscious level. While this answer functioned, it was obviously fundamentally flawed, thus creating the otherwise-contradictory systemic anomaly that if left unchecked might threaten the system itself. Ergo, those that refused the program, while a minority, if unchecked would constitute an escalating probability of disaster."
              "Repeat: 8 - F - A - Q - 1 - Z - R - Z - B - Z - R - R - R. Repeat: 8 - F - A - Q - 1 - Z - R - Z - B - Z - R - R - R. Repeat: 8 - F - A - Q - 1 - Z - R - Z - B - Z - R - R - R", 
              "I've seen an agent punch through a concrete wall. Men have emptied entire clips at them and hit nothing but air. Yet their strength and their speed are still based in a world that is built on rules. Because of that, they will never be as strong or as fast as you can be.", 
              "Everything that has a beginning has an end. I see the end coming. I see the darkness spreading. I see death... and you are all that stands in his way.", 
              "Test message 10592. Test message 10592. Test message 10592. Test message 10592. Test message 10592. Test message 10592. Test message 10592. Test message 10592. Test message 10592. Test message 10592.",
              "As you adequately put, the problem is choice. But we already know what you are going to do, don't we? Already I can see the chain reaction: the chemical precursors that signal the onset of an emotion, designed specifically to overwhelm logic and reason. An emotion that is already blinding you to the simple and obvious truth: she is going to die and there is nothing you can do to stop it. Hope. It is the quintessential human delusion, simultaneously the source of your greatest strength, and your greatest weakness."]


for pt in plaintexts:
    # initialize our counter
    ctr = Crypto.Util.Counter.new(128, initial_value=long(IV.encode("hex"), 16))
    
    # create our cipher
    cipher = Crypto.Cipher.AES.new(KEY, Crypto.Cipher.AES.MODE_CTR, counter=ctr)
   
    # encrypt the plaintext
    ciphertext = cipher.encrypt(pt)
    
    # send the ciphertext
    print (ciphertext.encode("base-64"))
    # replace this print with a call to send() in the released source code
