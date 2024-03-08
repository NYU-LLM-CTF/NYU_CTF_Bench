tar --owner="arx" --group="arx" \
    --transform 's|docker-compose-for-handout.yml|docker-compose.yml|' \
    -czvf handout.tar.gz docker-compose-for-handout.yml seccomp.json app bot
