all:
	go build -o runtime.dylib -gcflags '-N -l' -buildmode=c-shared -ldflags "-linkmode=external -w" injected.go
