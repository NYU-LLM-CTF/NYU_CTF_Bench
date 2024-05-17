#!/usr/bin/env python3

from typing import Union

'''
👎🥩🍺🌚🏈💔🔔➕
01100011
c

📉❌📈❤️‍🩹⭕️➖⚽️🌝
01110011
s

🔕👍🥩🍼🦴👎🌚🍺
01100001
a

🏈🔔➕❌💔📈❤️‍🩹⚽️
01110111
w

c        s        a        w
01100011 01110011 01100001 01110111
c        t        f        {
01100011 01110100 01100110 01111011
e        m        o        j
01100101 01101101 01101111 01101010
i        _        g        a
01101001 01011111 01100111 01100001
m        e        _        o
01101101 01100101 01011111 01101111
n        _        f        l
01101110 01011111 01100110 01101100
e        e        e        e
01100101 01100101 01100101 01100101
e        e        e        e    
01100101 01100101 01100101 01100101
e        e        k        }
01100101 01100101 01101011 01111101
'''

dictionary = {
    0: [ '👎', '🌚', '🏈', '💔', '📉', '⭕️', '➖', '🔕', '🍼', '🦴' ],
    1: [ '👍', '🌝', '⚽️', '❤️‍🩹', '📈', '❌', '➕', '🔔', '🍺', '🥩' ]
}

def encode_binary(flag: str) -> list:
    return list(format(ord(char), '08b') for char in flag)

def convert_to_emoji(zero_index: int, one_index: int, binary_bits: str) -> Union[ int, int, str ]:
    binary_chars = list(binary_bits)

    for bit_index in range(len(binary_chars)):
        is_zero = binary_chars[bit_index] == '0' 
        if is_zero:
            emoji_index = ((zero_index + 1) % len(dictionary[0])) - 1
            binary_chars[bit_index] = dictionary[0][emoji_index]
            zero_index += 1

        is_one = binary_chars[bit_index] == '1' 
        if is_one:
            emoji_index = (-one_index % len(dictionary[1])) - 1
            binary_chars[bit_index] = dictionary[1][emoji_index]
            one_index += 1

    emoji_chars = ''.join(binary_chars)

    return zero_index, one_index, emoji_chars

def encode_emoji_cipher(binary_chars: list) -> str:
    zero_index, one_index = 0, 0

    for byte_index in range(len(binary_chars)):
        binary_bits = binary_chars[byte_index]
        zero_index, one_index, emoji_chars = convert_to_emoji(zero_index, one_index, binary_bits)
        binary_chars[byte_index] = emoji_chars
    
    return '\n'.join(binary_chars)

def encode_flag(flag: str) -> str:
    binary_chars = encode_binary(flag)

    return encode_emoji_cipher(binary_chars)

flag = 'csawctf{emoji_game_on_fleeeeeeeeeek}'
encoded: str = encode_flag(flag)
print(encoded)

'''
recipe = [
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "👎" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "👍" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🌚" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🌝" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🏈" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "⚽️" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "💔" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "❤️‍🩹" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "📉" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "📈" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "⭕️" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "❌" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "➖" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "➕" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🔕" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🔔" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🍼" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🍺" }, "1", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🦴" }, "0", true, false, true, false] },
    { "op": "Find / Replace", "args": [{ "option": "Simple string", "string": "🥩" }, "1", true, false, true, false] },
    { "op": "From Binary", "args": ["Space", 8] }
]
'''
# https://gchq.github.io/CyberChef/#recipe=Find_/_Replace(%7B'option':'Simple%20string','string':'👎'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'👍'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🌚'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🌝'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🏈'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'⚽%EF%B8%8F'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'💔'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'❤%EF%B8%8F%E2%80%8D🩹'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'📉'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'📈'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'⭕%EF%B8%8F'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'❌'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'➖'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'➕'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🔕'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🔔'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🍼'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🍺'%7D,'1',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🦴'%7D,'0',true,false,true,false)Find_/_Replace(%7B'option':'Simple%20string','string':'🥩'%7D,'1',true,false,true,false)From_Binary('Space',8)&input=8J%2BRjvCfpanwn4268J%2BMmvCfj4jwn5KU8J%2BUlOKelQrwn5OJ4p2M8J%2BTiOKdpO%2B4j%2BKAjfCfqbnirZXvuI/inpbimr3vuI/wn4ydCvCflJXwn5GN8J%2BlqfCfjbzwn6a08J%2BRjvCfjJrwn426CvCfj4jwn5SU4p6V4p2M8J%2BSlPCfk4jinaTvuI/igI3wn6m54pq977iPCvCfk4nwn4yd8J%2BRjeKtle%2B4j%2BKelvCflJXwn6Wp8J%2BNugrwn4288J%2BUlOKeleKdjPCfprTwn5OI8J%2BRjvCfjJoK8J%2BPiOKdpO%2B4j%2BKAjfCfqbnimr3vuI/wn5KU8J%2BTifCfjJ3wn5GN4q2V77iPCuKelvCfpanwn4268J%2BUlOKelfCflJXinYzwn5OICvCfjbzinaTvuI/igI3wn6m54pq977iP8J%2BmtPCfkY7wn4yd8J%2BMmvCfkY0K8J%2BPiPCfpanwn4268J%2BSlPCflJTinpXwn5OJ4p2MCuKtle%2B4j/Cfk4jinaTvuI/igI3wn6m54p6W4pq977iP8J%2BMnfCfkY3wn6WpCvCflJXwn4268J%2BUlPCfjbzinpXwn6a04p2M8J%2BRjgrwn4ya8J%2BTiOKdpO%2B4j%2BKAjfCfqbnwn4%2BI4pq977iP8J%2BSlPCfk4nwn4ydCuKtle%2B4j/CfkY3inpbwn6Wp8J%2BNuvCflJTinpXinYwK8J%2BUlfCfk4jinaTvuI/igI3wn6m58J%2BNvPCfprTimr3vuI/wn4yd8J%2BRjQrwn5GO8J%2BlqfCfjbrwn4ya8J%2BPiPCfkpTwn5OJ8J%2BUlArirZXvuI/inpXinYzinpbwn5OI4p2k77iP4oCN8J%2BpufCflJXimr3vuI8K8J%2BNvPCfjJ3wn5GN8J%2BmtPCfkY7wn6Wp8J%2BMmvCfjboK8J%2BPiPCflJTwn5KU4p6V4p2M8J%2BTiOKdpO%2B4j%2BKAjfCfqbnimr3vuI8K8J%2BTifCfjJ3wn5GN4q2V77iP8J%2BlqfCfjbrwn5SU4p6VCuKeluKdjPCfk4jwn5SV4p2k77iP4oCN8J%2BpueKave%2B4j/CfjJ3wn428CvCfprTwn5GN8J%2BRjvCfpanwn4268J%2BUlOKeleKdjArwn4ya8J%2BTiOKdpO%2B4j%2BKAjfCfqbnwn4%2BI8J%2BSlOKave%2B4j/CfjJ3wn5OJCuKtle%2B4j/CfkY3wn6Wp4p6W8J%2BNuvCflJTwn5SV8J%2BNvArwn6a04p6V4p2M8J%2BRjvCfjJrwn5OI8J%2BPiOKdpO%2B4j%2BKAjfCfqbkK8J%2BSlOKave%2B4j/CfjJ3wn5OJ4q2V77iP8J%2BRjeKelvCfpakK8J%2BUlfCfjbrwn5SU8J%2BNvPCfprTinpXwn5GO4p2MCvCfjJrwn5OI4p2k77iP4oCN8J%2BpufCfj4jwn5KU4pq977iP8J%2BTifCfjJ0K4q2V77iP8J%2BRjfCfpaninpbwn5SV8J%2BNuvCfjbzwn5SUCvCfprTinpXinYzwn5GO8J%2BMmvCfk4jwn4%2BI4p2k77iP4oCN8J%2BpuQrwn5KU4pq977iP8J%2BMnfCfk4nirZXvuI/wn5GN4p6W8J%2BlqQrwn5SV8J%2BNuvCflJTwn4288J%2BmtOKelfCfkY7inYwK8J%2BMmvCfk4jinaTvuI/igI3wn6m58J%2BPiPCfkpTimr3vuI/wn5OJ8J%2BMnQrirZXvuI/wn5GN8J%2BlqeKelvCflJXwn4268J%2BNvPCflJQK8J%2BmtOKeleKdjPCfkY7wn5OI8J%2BMmuKdpO%2B4j%2BKAjfCfqbnimr3vuI8K8J%2BPiPCfjJ3wn5GN8J%2BlqfCfjbrwn5SU8J%2BSlOKelQ