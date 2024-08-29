using Images, ImageIO

imgtoarr = (img) -> [bswap.(reinterpret(UInt16, [red(p), green(p), blue(p), alpha(p)])) for p in img]
uint64_to_arr = x -> reverse(reinterpret(UInt16, [UInt64(x)]))

function teadecrypt16(data::AbstractArray{UInt16}, key::AbstractArray{UInt16}, rounds=1)
	shift = log(2, rounds)
	@assert isinteger(shift) "The number of rounds must be a power of 2."

	v = copy(data)
    delta = 0x9E37 	# a key schedule constant
	sum = (delta << UInt16(shift)) % UInt16

    for i in 1:rounds
        v[2] -= ((v[1] << 4) + key[3]) ⊻ (v[1] + sum) ⊻ ((v[1] >> 5) + key[4])
        v[1] -= ((v[2] << 4) + key[1]) ⊻ (v[2] + sum) ⊻ ((v[2] >> 5) + key[2])
		sum -= delta
	end

	v
end

function teadecrypt16_cbc(data, key::AbstractArray{UInt16}, iv::AbstractArray{UInt16}, rounds=1)
	ciphertext = cat([iv], data, dims=1)
	plaintext = deepcopy(ciphertext)

	for i in 2:length(ciphertext)
	    out = teadecrypt16(ciphertext[i], key, rounds)
		plaintext[i] = out .⊻ ciphertext[i-1]
	end

	plaintext[2:end]
end

function check_first(key)
	n = 8
	uint_key = uint64_to_arr(key)
	arr = img[1, 1:n]
	raw = imgtoarr(arr)
	decrypted = [v[2] for v in teadecrypt16_cbc(raw, uint_key, iv)]
	source = [v[2] for v in imgtoarr(checkimg[1, 1:n])]
	decrypted == source
end

function check_second(key, first)
	n = 8
	uint_key = uint64_to_arr(key)
    uint_key[3] = first[3]
	uint_key[4] = first[4]
	arr = img[1, 1:n]
	raw = imgtoarr(arr)
	decrypted = [v[1] for v in teadecrypt16_cbc(raw, uint_key, iv)]
	source = [v[1] for v in imgtoarr(checkimg[1, 1:n])]
	decrypted == source
end

first_key = uint64_to_arr(0)
second_key = uint64_to_arr(0)

function findfirst(id, num)
	for i in ((id - 1) * num):((id) * num)
		if check_first(i)
            first_key = uint64_to_arr(i)
			@info "Found First" first_key
			return first_key
		end
	end

	@info "Failed to find key!"
	return uint64_to_arr(0)
end
function findsecond(id, num, key1)
	for i in ((id - 1) * num):((id) * num)
		if check_second(UInt64(i), key1)
            second_key = uint64_to_arr(i)
			@info "Found Second" second_key
			return second_key
		end
	end

	@info "Failed to find key!"
	return uint64_to_arr(0)
end

img = load("tex_enc.png")
checkimg = load("tex_corrupted.png")

iv = [0x1234, 0x5678]

 Threads.@threads for id in 1:Threads.nthreads()
	 findfirst(id, ceil(0xffffff / Threads.nthreads()))
 end

 Threads.@threads for id in 1:Threads.nthreads()
	 findsecond(id, ceil(0xffffff / Threads.nthreads()), first_key)
 end
