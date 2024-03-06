from bs4 import BeautifulSoup

with open('List of Pokémon by National Pokédex number - Bulbapedia, the community-driven Pokémon encyclopedia.html') as f:
	soup = BeautifulSoup(f,'html.parser')

tables = [
    [
        [td.get_text(strip=True) for td in tr.find_all('td')] 
        for tr in table.find_all('tr')
    ] 
    for table in soup.find_all('table')
]
list_of_pokemon = []
for i in range(1,10):
	for j in range(len(tables[i])):
		string = ""
		if j != 0:
			for k in range(len(tables[i][j])):
				if k > 1:
					string += tables[i][j][k]
					string += '-'
			list_of_pokemon.append(string[:-1])
with open('list.txt','w') as f:
	print(*list_of_pokemon, sep='\n', file=f)
