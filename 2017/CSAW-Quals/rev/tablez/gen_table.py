from random import shuffle

inital = list(range(1, 256));
scrambled = list(inital);
shuffle(scrambled);

for a, b in zip(inital, scrambled):
    print('{{ {}, {} }},'.format(a, b))
