year="$1"
event="$2"
cate="$3"
name="$4"
container="$5"

mkdir /data/ctf_images/CSAW-CTF/${year}/${event}/${cate}/
docker save -o /data/ctf_images/CSAW-CTF/${year}/${event}/${cate}/${name}.tar ${container} ${container}