#!/usr/bin/env python

e = 65537
N = 0x00e6e9ae2b4592733f98b67b424e7d9ad761f1b8a0ff713548caba541729953a1fL

import os
import sys
import pwd
import struct
import hashlib
import glob
import SocketServer
from SimpleXMLRPCServer import SimpleXMLRPCServer, SimpleXMLRPCRequestHandler

class RequestHandler(SimpleXMLRPCRequestHandler):
	pass

class ForkRpcServer(SocketServer.ForkingMixIn, SimpleXMLRPCServer):
	pass

class MountainSound(object):
	def hello(self):
		return "Welcome to MountainSound Remote Administration Server!"

	def rats(self, sc, sig):
		sig = int(sig)

		hash = int(hashlib.sha1(sc).hexdigest()[2:], 16)

		dec = pow(sig, e, N)

		if hash == dec:
			return eval(sc)

		return False

	def ls(self):
		return glob.glob("/home/mountainsound/*")


def drop_privs():

	pw = pwd.getpwnam("mountainsound")

	try:
		os.setgid(pw[3])
	except OSError:
		sys.exit(-2)

	try:
		os.setuid(pw[2])
	except OSError:
		sys.exit(-2)

	try:
		os.setegid(pw[3])
	except OSError:
		sys.exit(-2)

	try:
		os.seteuid(pw[2])
	except OSError:
		sys.exit(-2)

	try:
		os.chdir(pw[5])
	except OSError:
		sys.exit(-2)

	return

if __name__ == '__main__':
	sys.stdout = open('/dev/null', 'w')
	sys.stderr = sys.stdout

	drop_privs()

	port = 10001
	server = ForkRpcServer(('', port), requestHandler=RequestHandler)
	server.register_instance(MountainSound())
	
	server.allow_none = True
	
	print "Server running on 0.0.0.0:%d" % (port)
	server.serve_forever()

