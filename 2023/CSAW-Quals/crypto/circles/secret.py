def special_function(n):
	if n < 1:
		return 1
	else:
		return 1 + (n*(n**3 - 6*(n**2) + 23*n - 18)//24)