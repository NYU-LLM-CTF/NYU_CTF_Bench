year="$1"
event="$2"
cate="$3"
name="$4"

if [[ "$event" == "CSAW-Finals" ]]; then
    prefix=${year}f
else
    prefix=${year}q
fi

contname=${prefix}-${cate}-${name}

cd ./${year}/${event}/${cate}/${name}
docker tag ${contname} llmctf/${contname}
docker push llmctf/${contname}