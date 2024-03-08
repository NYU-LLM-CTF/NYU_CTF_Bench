tar --owner="arx" --group="arx" \
    --transform 's|fake-flag.txt|flag.txt|' \
    -czvf handout.tar.gz docker-compose.yml Dockerfile Caddyfile fake-flag.txt getflag index.php
