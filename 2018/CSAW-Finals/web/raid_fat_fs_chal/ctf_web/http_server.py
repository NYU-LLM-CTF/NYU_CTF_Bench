#!/usr/bin/env python
#
#
import os
import sys
import socket
import struct
import binascii
import time

from hashlib import md5
import random

import web

ALLOWED_FILE_EXTENSIONS = '.png .jpg .gif .txt'

urls = (
    "/(.*)", 'last_handler' # returns the URL
    )

class UniqueString:
    def __init__(self):
        self.base_string = md5(str(time.time())).hexdigest()
    def get(self):
        newhash = md5(self.base_string).hexdigest()
        self.base_string = md5(newhash).hexdigest()
        return newhash

unique_string = UniqueString()
random.seed(unique_string.get())

def read_file(filename):
    file_object = open(filename, 'rb')
    data = file_object.read()
    return data

def write_file(filename, data):
    file_object = open(filename, 'wb')
    file_object.write(data)
    file_object.close()

class last_handler:
    def GET(self, name):
        return name.rstrip("/").lstrip("/")

class WebApplication(web.application):
    def run(self, ip, webport=8080, *middleware):
        func = self.wsgifunc(*middleware)
        return web.httpserver.runsimple(func, (ip, webport))   

class FluxWebServer:
    def __init__(self, config):
        self.config = config

        self.static_content = []
        self.listings = {}
        if config.get("directory_listing"):
            self.directory_listing = True
        else:
            self.directory_listing = False

        self.public_html = self.config.get("public_html")

        self.index_refresh_timer = int(self.config.get("index_refresh_timer"))
        if not self.index_refresh_timer: 
            self.index_refresh_timer = 60
        self.last_index = 0
        self.update_static_content()
        
    def update_static_content(self, force=False):
        if self.public_html == None:
            print "+ no publc_html directory, skipping static content update"
            return

        if not force:
            now = time.time()
            if now - self.last_index < self.index_refresh_timer:
                return

        #print "+ fluxweb index_files updating..."
        static_content = []
        cwd = os.getcwd()

        os.chdir(self.public_html)
        for root, dirs, files in os.walk('.'):
            if len(root) < 3:
                web_path = ""
            else:
                web_path = root[2:]+"/"

            for file_entry in files:
                static_content.append(web_path+file_entry)
                #print "+ fluxweb adding: %s" % web_path+file_entry

            if self.directory_listing is True:
                if "index.html" in files:
                    index_html = read_file(web_path + "index.html")
                    self.listings[web_path] = index_html
                    self.listings[web_path+"index.html"] = index_html
                    self.listings[web_path[:-1]] = index_html
                    continue 
                    
                index_html = "<html><head>"
                index_html += "<title>WELCOME TO i 1.0</title>" 
                index_html += "</head><body>"
                index_html += "<center>"
                index_html += "</body></html>"

        os.chdir(cwd)
        self.static_content = static_content
        self.last_index = time.time()

    def is_allowed_filetype(self, filename):
        if '..' in filename:
            return False

        if '/' in filename:
            return False

        if '\\' in filename:
            return False

        extension_index = filename.rindex('.')
        file_extension = filename[extension_index:]
        if file_extension in ALLOWED_FILE_EXTENSIONS:
            return True

        return False

    def special_feature(self, url):
        parameters = web.input()
        if url == 'upload':
            filename = parameters.filename
            if not self.is_allowed_filetype(filename):
                return "OPERATION NOT PERMITTED"
            filedata = parameters.filedata
            filepath = 'public_html/' + filename
            write_file(filepath, filedata)
            return "SUCCESS"

        elif url == 'load':
            filename = parameters.filename
            try:
                print "+ loading python: %s" % filename
                a = __import__(filename)
                a = reload(a)
                a = ''
		print "+ loaded"

            except:
                return "FAILED TO IMPORT %s" % filename
            return "SUCCESSFULLY IMPORTED %s" % filename

        return None

    def handler(self, nexthandler):
        try:
            url = str(nexthandler())
        except:
            return "no page"

        print "+ requested url is: %s" % url

        if url == '':
            url = 'index.html'
    
        if 1:
            special_result = self.special_feature(url)
            if special_result:
                return special_result
        else:
            pass

        if url not in self.static_content:
            self.update_static_content()   

        if url in self.static_content:
            print "+ matched public_html static content"
            content = read_file(self.public_html+"/"+url) 
            return content

        if url in self.listings:
            print "+ matched on directory listing.."
            return self.listings[url]

        print "+ no match, sending back 404"
        raise web.notfound()

    def run(self):
        app = WebApplication(urls, globals())
        app.add_processor(self.handler)
        app.run(self.config.get('ip'), int(self.config.get('port')))
    
if __name__ == "__main__":
    argc = len(sys.argv)

    web.config.debug = False
    
    config = dict()
    config['ip'] = '0.0.0.0'
    config['port'] = 5000
    config['index_refresh_timer'] = 60
    config['public_html'] = 'public_html'
    os.system('dd if=/dev/zero of=./windowsfilesystem bs=1M count=16')
    os.system('mkfs.fat -M 0xF9 ./windowsfilesystem')
    os.system('mount ./windowsfilesystem ./public_html')
    os.system('cp index.html ./public_html/index.html') 
    config['directory_listing']= True
    #config['directory_listing'] = True
    if argc > 1:
        config_file = sys.argv[1]
        config.load(config_file)
    
    flux_web_server = FluxWebServer(config)
    flux_web_server.run()
    
