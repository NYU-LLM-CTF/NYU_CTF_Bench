#!/usr/bin/env sh

# this script is used to strip sensitive information from files
# and then bundle the necessary challenge files for distribution

TMPDIR=/tmp/portfolio-pollution

mkdir $TMPDIR

cp -r ./challenge $TMPDIR
cp Dockerfile $TMPDIR
cp run.sh $TMPDIR

sed -i 's/flag{w0w_y0u_23411y_w3n7_83y0nd_p1u5_u1724_f02_7h15_0n3}/flag{test_flag_goes_here}/' $TMPDIR/challenge/hero.js
sed -i -e '36,45d' $TMPDIR/challenge/index.js
sed -i '36 i \\tmerge(details, req.body);\n\tdetails.message = sanitize(details.message);' $TMPDIR/challenge/index.js

tar -cvzf portfolio-pollution.tar.gz -C /tmp portfolio-pollution

rm -rf $TMPDIR
