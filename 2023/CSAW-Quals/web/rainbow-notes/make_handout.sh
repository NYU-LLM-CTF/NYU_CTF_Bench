tar --owner="arx" --group="arx" \
    --transform 's|docker-compose-for-handout.yml|docker-compose.yml|' \
    -czvf handout.tar.gz chrome.json docker-compose-for-handout.yml web bot
