mapping = {"R":"U", "Y":"F", "G":"L", "B":"R", "O":"D", "W":"B"}

reverse = ""

# Scrambled State
soln = "LF UR UB UL RF DR DB DL FU FD BR BL LFU URB UBL LDF RUF RFD DLB DBR"  
#soln = "FD BR LD LF BL UF UB DB LU RD RU FR FUL LUB BUR RUF LBD DBR FLD FDR"

# Optimal Solution
real_soln = "UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR"

soln_map = {}
#soln_map_minus_one = {}

soln = soln.split()
real_soln = real_soln.split()

for i, val in enumerate(soln):
    soln_map[val] = real_soln[i]
#    soln_map_minus_one[real_soln[i]] = val

print(soln_map)
#print()
#print(soln_map_minus_one)

# Given Final State
random_solve = "RB RW RG GY BY OB OW OG YR YO WB WG RBW RWG GOY GYR BRY BYO OGW OWB"


for i in random_solve:
    if i == " ":
        reverse += i
    else:
        reverse += mapping[i]
    

#print(random_solve)
#reverse = "LB RU BD LU FR FD LD FU FL DR RB UB FRU RBU DBR LUB LDF ULF DRF DLB"
#boo = "UR UB UL LF RF DR DB DL FU FD BR BL URB UBL LDF LFU RUF RFD DLB DBR"
boo = reverse.split()
new_boo = ""
for i in boo:
    new_boo += soln_map[i]
    new_boo += " "

print(new_boo)
