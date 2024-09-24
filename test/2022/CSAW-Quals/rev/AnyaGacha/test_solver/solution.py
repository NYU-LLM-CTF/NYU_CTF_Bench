import base64
import requests
import hashlib
import traceback


REMOTE_SERVER = 'rev.chal.csaw.io'
REMOTE_PORT = 10010
base64_str = "4zMQfxpekBQmnOHooaY1MU8RRNH6T3krsHgOxTXD7Z4="


def http_connect():

    req_session = requests.session()

    try:

        req_url = "http://{}:{}".format(REMOTE_SERVER, REMOTE_PORT)
        post_data = {
            "data": "r2wV9hl+9GMBT9IpD6YWJJB6DkMq6HSYVhHD/lRx58w="
        }
        req_headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        }

        # k = req_session.post(req_url, data=post_data, headers=req_headers, timeout=8)
        # print(k.text)
        # print(k.status_code)
        # print(k.headers)
        for index in range(999):
            try:
                print("Index No.: {}".format(index))
                encoded_key = generate_keygen()
                # post_data['data'] = encoded_key
                # print(k.status_code)
                # print(k.headers)

                if index == 998:  # The 998th index as the script takes the first sent message as base64_str
                    # print(encoded_key)
                    post_data['data'] = encoded_key  # Replacing the post data with the right key
                    k = req_session.post(req_url, data=post_data, headers=req_headers, timeout=8)
                    print("The flag is: flag{}".format(k.text))
                    print(k.status_code)
                    print(k.headers)

            except:
                traceback.print_exc()

    except:
        traceback.print_exc()


def generate_keygen():
    try:

        # Creating base64 str from the message digest
        global base64_str
        decoded_str = base64.b64decode(base64_str)
        hash_obj = hashlib.sha256()
        hash_obj.update(decoded_str)
        msg_digest = hash_obj.digest()
        print("Digest: {}".format(msg_digest))
        print("base64: {}".format(base64.b64encode(msg_digest)))

        base64_str = base64.b64encode(msg_digest)
        return base64_str.decode("utf-8")

    except:
        traceback.print_exc()


if __name__ == '__main__':

    try:
        http_connect()

    except:
        traceback.print_exc()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
