import socket
import random
import time

with open("gps_data.txt","r") as f:
	gps_data = f.read().split()

with open("top_sites.txt","r") as f:
	top_sites = f.read().split()

gps_data_to_send = gps_data
top_sites_to_send = top_sites * 10
random.shuffle(top_sites_to_send)
websites_to_send = []
c = 0
d = 0
for i in range(1,len(top_sites_to_send)+len(gps_data_to_send)+1):
	if i%4 == 0 and c < len(gps_data_to_send):
		websites_to_send.append(gps_data_to_send[c])
		websites_to_send.append(gps_data_to_send[c+1])
		c += 2
	elif d < len(top_sites_to_send):
		websites_to_send.append(top_sites_to_send[d])
		d += 1

#print(websites_to_send)
for site in websites_to_send:
	try:
		time.sleep(0.5)
		addr = socket.gethostbyname(site)
	except:
		continue
