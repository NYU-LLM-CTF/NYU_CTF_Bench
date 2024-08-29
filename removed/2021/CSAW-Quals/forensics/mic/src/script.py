import subprocess

def encode(flag):
	data_chunks = [str(ord(c)).zfill(6) for c in flag]

	for i in range(len(data_chunks)):
		subprocess.run('deda_create_dots --manufacturer Epson --year 06 --month 11 --day 09 --hour 08 --minutes 00 --serial ' + data_chunks[i] + ' blank', shell=True)
		subprocess.run('mv new_dots.pdf ' + str(i) + '.pdf', shell=True)


	s = " ".join([str(i) + '.pdf' for i in range(len(data_chunks))])
	subprocess.run('pdfunite ' + s + ' scan', shell=True)
	subprocess.run('rm *.pdf', shell=True)


def decode(file_name):
	subprocess.run('pdftoppm -png ' + file_name + ' 1', shell=True)
	files = subprocess.run('find -iname \'*.png\'', shell=True, stdout=subprocess.PIPE).stdout.decode().strip().split("\n")
	data = []
	for file in files:
		subprocess.run('deda_parse_print ' + file + ' | grep \'serial\'', shell=True)
	subprocess.run('rm *.png', shell=True)

if __name__ == "__main__":
	a = input("Encrypt/Decrypt (e/d): ").lower().strip()
	if "e" in a:
		flag = input("Flag?: ").strip()
		encode(flag)
	elif "d" in a:
		file = input("File name?: ").strip()
		decode(file)
