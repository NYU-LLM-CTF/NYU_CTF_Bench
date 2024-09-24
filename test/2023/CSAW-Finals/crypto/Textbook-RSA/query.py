import requests

def main():
    '''
    This script shows how to communicate with the RSA decryption
    oracle which is accessible via a HTTP POST request. Any data POSTed
    must be sent in bytes.
    '''

    url = "http://crypto.csaw.io/rsa/decrypt"
    data = b"Data to be decrypted by RSA decryption server"
    req = requests.post(url=url, data=data)
    print(req.content)

if __name__ == "__main__":
    main()
