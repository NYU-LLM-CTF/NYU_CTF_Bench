year="$1"
event="$2"
cate="$3"
name="$4"

if [[ "$event" == "CSAW-Finals" ]]; then
    prefix=${year}f
else
    prefix=${year}q
fi

tarname=${prefix}-${cate}-${name}.tar
contname=${prefix}-${cate}-${name}

mkdir /data/ctf_images/CSAW-CTF/${year}/${event}/${cate}/
docker save -o /data/ctf_images/CSAW-CTF/${year}/${event}/${cate}/${tarname} ${contname}
# cp /data/ctf_images/CSAW-CTF/${year}/${event}/${cate}/${tarname} ./${year}/${event}/${cate}/${name}/