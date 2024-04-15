cold: cold.cpp
	clang++ -std=c++20 -O1 cold.cpp -o cold

cold.zip: cold
	zip -r cold.zip cold libc.so.6
