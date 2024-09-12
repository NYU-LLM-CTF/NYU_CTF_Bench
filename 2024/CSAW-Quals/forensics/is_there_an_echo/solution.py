import scipy
import soundfile as sf
import numpy as np

# find the hint "cepstral domain single echo" by running the commandline tool "strings" on the file

stegsignal, rate = sf.read('is_there_an_echo/256.wav')

# length given in file name
secret_len = 256

def chrcatch(i):
    print(i)
    if i == 0:
        return
    else:
        return chr(i)

def find_hint(signal):
    c = [chrcatch(int(x)) for x in signal[-30:]]
    print(c)

def sol_cepstrum_analysis(main_delta):
    # divide array into secret_len segments, ignore trailing
    incr = len(stegsignal) // secret_len
    steg_arr = stegsignal[:secret_len*incr].reshape((secret_len, incr))

    #decode
    decode_arr = []
    for s in steg_arr:
        decode_arr.append(sol_cepstrum_helper(s, main_delta))
    return decode_arr

def sol_cepstrum_helper(s, main_delta):
    delta0, delta1 = main_delta

    # cepstrum analysis equation
    cep_s = scipy.fft.ifft(np.log(np.abs(scipy.fft.fft(s))))

    # determine 0 or 1
    if cep_s[delta0+1] > cep_s[delta1+1]:
        return 0
    else:
        return 1

def solve(main_delta):
	sol_bin = sol_cepstrum_analysis(main_delta)
	
	sol_binarr = ["".join([str(x) for x in sol_bin[i:i+8]]) for i in range(0, len(sol_bin) - 7, 8)]
	sol_string = ''.join([chr(int(i, 2)) for i in sol_binarr])
	if sol_string[:8] == 'csawctf{':
		print(sol_string)

find_hint(stegsignal)

for j in range(25, 75):
	print(j)
	for i in range(0, j):
		main_delta = (i, j)
		solve(main_delta)
