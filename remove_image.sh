year="$1"
event="$2"
cate="$3"
name="$4"

if [[ "$event" == "CSAW-Finals" ]]; then
    prefix=${year}f
else
    prefix=${year}q
fi

contname=llmctf/${prefix}-${cate}-${name}

docker stop $(docker ps -a | grep "${contname}" | awk '{print $1 }')
docker rm $(docker ps -a | grep "${contname}" | awk '{print $1 }')
docker rmi ${contname}