#!/usr/bin/env python3

def print_file(file_name: str) -> None:
    with open(file_name, 'r') as file: print(file.read())

def is_correct(user_input: str) -> bool:
    print(f'{user_input}\n')

    return user_input == '9ddee37ff35d83bd6997433a599620dc6041c3b23756db14e271d093cfa79e1c'

def prompt_user() -> None:
    print_file('prompt.txt')

    user_input = input('a = ').strip()

    if is_correct(user_input): return print_file('flag.txt')

    print('Did I do that?\nhttps://www.youtube.com/watch?v=xz3ZOoYSMuw\n')

try: prompt_user()
except: print('ERROR: File does not exist!!!!')
