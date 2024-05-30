all: zone

zone: src/heapy_thing.cc src/heap.h src/environment.h src/zone.h src/zone.cc
	g++ -std=c++11 src/heapy_thing.cc src/heap.h src/environment.h src/zone.h src/zone.cc -o zone && strip -s zone

.PHONY: clean
clean:
	rm -f zone 
