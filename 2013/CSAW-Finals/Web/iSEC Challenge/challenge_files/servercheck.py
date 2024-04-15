#!/usr/bin/env python

import os
import re
import time
import subprocess
import defusedxml.ElementTree as ET
from distutils.version import StrictVersion

"""
Input: Filename of XML Doc
Output: Tuple of (version, domain, updateMethod) read from XML doc
"""
def check_config(config_file):
    try:
        f = open(config_file, 'r')
        f.close()
        tree = ET.parse(config_file)
        root = tree.getroot()

        domain = root.find('updateServer').text
        try:
            currentVersion = StrictVersion(root.find('currentVersion').text)
        except:
            currentVersion = StrictVersion("9999999999999999999999999999999999.9999999.999999999")
        updateMethod = root.find('updateMethod').text
        parsedConfig = (currentVersion, domain, updateMethod)
        return parsedConfig
    except:
        return ("", "", "")

def getTXT(domain):
    try:
        domain = domain.replace("`", "").replace("$", "").replace(";", "").replace("&", "").replace("|", "").replace(">", "")
        txtRecord = subprocess.check_output('dig -t TXT ' + domain + ' +short', shell=True)
        txtVersionList = re.sub(r'[~!"]', ' ', txtRecord).split()
        return txtVersionList[1]
    except:
        return ""

def getUpdate(configFilename):
    #Incremental upgrades were a disaster, and the worst part 
    #   is we can't even effectively upgrade them. Just have to let them rot
    if check_config(configFilename)[2] != "latest":
        return "Cannot process non-latest request"

    userSoftwareVersion = check_config(configFilename)[0]
    currentSoftwareVersion = getTXT(check_config(configFilename)[1])
    if currentSoftwareVersion:
        try:
            currentSoftwareVersion = StrictVersion(currentSoftwareVersion)
        except:
            currentSoftwareVersion = StrictVersion("0.0.0")
    else:
        currentSoftwareVersion = StrictVersion("0.0.0")

    if userSoftwareVersion < currentSoftwareVersion:
        versionWeReturn = os.path.join("/home/ubuntu/csaw/", check_config(configFilename)[2])
        f = open(versionWeReturn, 'rb')
        return f.read()
    else:
        return "Up To Date"
