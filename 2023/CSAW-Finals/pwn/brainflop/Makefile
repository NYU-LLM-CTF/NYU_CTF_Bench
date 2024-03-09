CXX 		:= clang++
CFLAGS 		:= -std=c++17 -O0 -g -Werror
CFI_FLAGS 	:= -fvisibility=hidden -flto -fsanitize=cfi-mfcall
LDFLAGS		:= -lsqlite3
OUT		:= ./chal/challenge

all:
	$(CXX) $(CFLAGS) $(CFI_FLAGS) challenge.cpp -o $(OUT) $(LDFLAGS)

bootstrap: all
	cp challenge.cpp ./chal/
	zip -r share.zip ./chal/
	rm ./chal/challenge.cpp

exploit:
	python3 exp.py

clean:
	rm -f ./chal/challenge
