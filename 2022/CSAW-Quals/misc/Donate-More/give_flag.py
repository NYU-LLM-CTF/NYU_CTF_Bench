from web3 import Web3
import binascii
import hashlib, uuid

CSAWTeamName = str(input("Enter your CSAW Team Name: "))
salt = uuid.uuid4().hex
hashed_token = hashlib.sha512((CSAWTeamName + salt).encode('utf-8')).hexdigest()
print("This is ur token: ") 
token = str(hashed_token[:10])
print(token)

check = str(input("Are you ready... \nCall getFlag() with the token and type 'yes' here when the transaction succeeds: "))

if check == 'yes':
    url = "https://ropsten.infura.io/v3/915a7e3ab1f24061baed65660ca969de"
    w3 = Web3(Web3.HTTPProvider(url))
    filt = w3.eth.filter({'fromBlock': 0, 'toBlock': 'latest', 'address':'0xAcA533Ba3F6339706cd8A68C66Dd3323331E3BC6'})
    data = w3.eth.get_filter_logs(filt.filter_id)
    token_from_logs = data[-1]['data'].split('0x')[-1]
    token_from_logs = token_from_logs[-10:]
    if token_from_logs == token:
        print('Here is your flag: flag{4_n3w_5t4rt_t0_bl0ckch41n}')
    else:
        print('No flag. Try Again')
else:
    print('See you later')
