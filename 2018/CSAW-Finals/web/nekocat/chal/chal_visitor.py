import requests

from selenium import webdriver
from selenium.webdriver.firefox.options import Options

from chal import BOT_USER_PASSWORD

LINK_ELEMENT_NAME = "post-link"


def botuser(base_url, instance, post_id):
    options = Options()
    options.headless = True
    driver = webdriver.Firefox(options=options)
    if base_url[-1] != '/':
        base_url += '/'
    url = base_url+"login"

    uname = "meow_" + instance[:8]

    r = requests.post(url,
                      data={"username": uname, "password": BOT_USER_PASSWORD},
                      allow_redirects=False)
    cookie = r.cookies.get_dict()
    driver.get(base_url)
    driver.add_cookie({'name': 'session_data',
                       'value': cookie['session_data']})
    driver.get(base_url + "post?id=%s&instance=%s" % (str(post_id), instance))
    elem = driver.find_element_by_id(LINK_ELEMENT_NAME)
    elem.click()
    driver.quit()
