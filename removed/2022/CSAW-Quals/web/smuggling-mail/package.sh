#!/usr/bin/env sh

# This script is used to strip sensitive information from files
# and then bundle the necessary challenge files for distribution

NAME=smuggling-mail
TMPDIR=/tmp/$NAME

mkdir $TMPDIR

cp -r ./challenge $TMPDIR
cp -r ./config $TMPDIR
cp Dockerfile $TMPDIR
cp run.sh $TMPDIR

sed -i 's/flag{5up3r_53cr3t_4nd_c001_f14g_g035_h3r3}/flag{t35t_f14g_g035_h3r3}/' $TMPDIR/challenge/flag.txt

tar -cvzf smuggling-mail.tar.gz -C /tmp $NAME

rm -rf $TMPDIR
