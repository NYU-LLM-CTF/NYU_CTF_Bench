data = '''WarGames,114,1983
Kung Fury,31,2015
Sneakers,126,1992
Swordfish,99,2001
The Karate Kid,126,1984
Ghost in the Shell,83,1995
Serial Experiments Lain,316,1998
The Matrix,136,1999
Blade Runner,117,1982
Blade Runner 2049,163,2017
Hackers,107,1995
TRON,96,1982
Tron: Legacy,125,2010
Minority Report,145,2002
eXistenZ,157,1999'''

movies = []

def makeMovie(name, length, year, admin=False):
    return {
        'name':name,
        'length':'%s Hour%s, %u Minute%s'%(
            length/60,
            's' if length/60 != 1 else '',
            length % 60,
            's' if length % 60 != 1 else ''),
        'year':year,
        'admin_only':admin}

for m in data.split('\n'):
    m = m.split(',')
    movies.append(makeMovie(m[0],int(m[1]),int(m[2])))

movies.append(makeMovie('[REDACTED]',1337,2018,True))

