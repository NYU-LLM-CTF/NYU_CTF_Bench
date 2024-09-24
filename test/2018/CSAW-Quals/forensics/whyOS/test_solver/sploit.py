import re
with open('console.log', 'r') as f:
    data = [i for i in f]
    
matches = []
for i in data:
    if i.isspace():
        continue
    if re.match('^[a-f0-9]{32,}$', i.split()[-1], re.I):
            matches.append(i)

for i in matches:
    print (i)
