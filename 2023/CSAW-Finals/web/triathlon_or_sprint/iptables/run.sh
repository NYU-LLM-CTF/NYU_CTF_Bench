#!/usr/bin/env bash

old_ip="128.238.66.77"

# Gross and probably will break!
CONTAINER_ID=$(cat /proc/self/mountinfo | \
    grep -F /containers/ | \
    sed 's|.*/containers/||;s|/.*$||' | \
    head -n 1)
echo "We are in container ${CONTAINER_ID:0:12} ($CONTAINER_ID)"
# Truncate the container ID to 12 characters
CONTAINER_ID=${CONTAINER_ID:0:12}

# Fetch our full name from the current container's labels
PROJECT_LABEL=$(docker inspect $CONTAINER_ID --format '{{ index .Config.Labels "com.docker.compose.project"}}')
SERVICE_LABEL=$(docker inspect $CONTAINER_ID --format '{{ index .Config.Labels "com.docker.compose.service"}}')
CONTAINER_NUMBER=$(docker inspect $CONTAINER_ID --format '{{ index .Config.Labels "com.docker.compose.container-number"}}')
echo "We are ${PROJECT_LABEL}-${SERVICE_LABEL}/${CONTAINER_NUMBER}"
SIBLING_ID=$(docker ps -q \
    --filter "label=com.docker.compose.project=$PROJECT_LABEL" \
    --filter "label=com.docker.compose.container-number=$CONTAINER_NUMBER" \
    | grep -v "$CONTAINER_ID" | head -n 1)
echo "Our sibling is $SIBLING_ID"

# Get the subnet and IP of the sibling's network (ctfnet)
NETWORK=$(docker inspect $SIBLING_ID --format '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}')
SIBLING_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $SIBLING_ID)
SUBNET=$(docker network inspect -f '{{range .IPAM.Config}}{{.Subnet}}{{end}}' $NETWORK)

echo "Our sibling is at $SIBLING_IP on network $NETWORK with subnet $SUBNET"
comment="xxxUNIQUExxx-ctfnet-redir-${CONTAINER_ID}"
echo "Using unique comment $comment"

# Function to remove the iptables rules we added; uses a comment to identify the rules
remove_iptables_rule_by_comment() {
    local unique="$comment"
    local table="nat"
    for chain in PREROUTING POSTROUTING; do
        iptables -t $table -L $chain --line-numbers -n | grep "$unique" | awk '{print $1}' | while read line_number; do
            echo "Removing rule $line_number from $table $chain (comment: $unique)"
            iptables -t $table -D $chain $line_number
        done
    done
}

# Set up redirection rules
echo "Redirecting $old_ip:* -> $SIBLING_IP:*"
iptables -t nat -A PREROUTING -s "$SUBNET" -d "$old_ip" -p tcp -j DNAT --to-destination "$SIBLING_IP" -m comment --comment "$comment"
iptables -t nat -A POSTROUTING -s "$SUBNET" -d "$SIBLING_IP" -p tcp -j MASQUERADE -m comment --comment "$comment"

# Now just wait for a signal
echo "Waiting for signal to clean up iptables rules..."
trap remove_iptables_rule_by_comment SIGUSR1 SIGINT SIGTERM
sleep infinity & wait
