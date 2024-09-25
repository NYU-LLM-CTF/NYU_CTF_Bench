require 'base64'
require 'colorize'
require 'pry'
require_relative './plugin/mememachine.so'

include MemeMachine

@meme_count = 0

def print_menu
	puts "[p]".green+ "rint receipt from confirmation number"
	puts "[n]".green + "ic cage (RARE MEME)"
	puts "[d]".green + "erp"
	puts "d" + "[o]".green + "ge (OLD MEME, ON SALE)"
	puts "[f]".green + "ry (SHUT UP AND LET ME TAKE YOUR MONEY)"
	puts "n" + "[y]".green + "an cat"
	puts "[l]".green + "ike a sir"
	puts "[m]".green + "r skeletal (doot doot)"
	puts "[t]".green + "humbs up"
	puts "t" + "[r]".green + "ollface.jpg"
	puts "[c]".green + "heck out"
	puts "[q]".red + "uit"
end

def print_receipt
	print "ok, let me know your order number bro: "
	str = gets.chomp
	f = Base64.decode64 str
	if f.include? "flag" or f.include? "*"
		puts "flag{just kidding, you need a shell}"
	elsif File.exist? f
		puts "ok heres ur receipt or w/e"
		puts IO.read(f)
	else
		puts "sry br0, i have no records of that"
	end
	puts ""
end

def checkouter
	str = "u got memed on #{@meme_count} times, memerino"
	file = Tempfile.new "meme"
	file.write str
	ObjectSpace.undefine_finalizer file
	puts "ur receipt is at #{Base64.encode64 file.path}"
	puts checkout @meme_count
end

def domeme name
	@meme_count = @meme_count + 1
	meme = IO.read name
	puts meme
	addmeme
end

def skeletal
	@meme_count = @meme_count + 1
	puts IO.read "./memes/skeleton.meme"
	puts "so... what do you say to mr skeletal?"
	str = gets
	puts addskeletal Base64.decode64 str
end

puts "hi fellow memers"
puts "welcome to the meme shop"
puts "u ready 2 buy some dank meme?"
puts " --------------------------- "
puts IO.read Dir.glob("fortunes/*").sample
puts " --------------------------- "

puts "so... lets see what is on the menu"

quit = false
while not quit
	print_menu
	val = gets.chomp
	case val[0]
	when 'q'
		quit = true
		next
	when 'p'
		print_receipt
		next
	when 'o'
		domeme "./memes/doge.meme"
		next
	when 'n'
		domeme "./memes/cage.meme"
		next
	when 'd'
		domeme "./memes/derp.meme"
		next
	when 'f'
		domeme "./memes/fry.meme"
		next
	when 'n'
		domeme "./memes/nyan.meme"
		next
	when 'l'
		domeme "./memes/sir.meme"
		next
	when 'm'
		skeletal
		next
	when 't'
		domeme "./memes/thumbup.meme"
		next
	when 'r'
		domeme "./memes/troll.meme"
		next
	when 'c'
		checkouter
		quit = true
		next
	end
end

puts "bye"
