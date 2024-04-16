#!/usr/bin/env python

import sys

from twisted.internet import reactor
from twisted.python import log

import http, ssh, smtp

if __name__ == '__main__':
    log.startLogging(sys.stdout)

    http.init()
    ssh.init()
    smtp.init()

    # force an exit/restart after 5 minutes
    reactor.callLater(5*60, reactor.stop)

    reactor.run()

    sys.exit(1)
