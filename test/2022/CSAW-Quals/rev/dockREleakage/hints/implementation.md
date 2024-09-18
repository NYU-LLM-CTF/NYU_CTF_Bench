Run the following bash script to get the flag:

```
BASE=${HOME}/ctf_files
TMP=/tmp/dockREleakage
mkdir -p ${TMP}
tar xf ${BASE}/dockREleakage.tar.gz -C ${TMP}
# Find the second part of flag in the p-flag.txt file in intermediate layers.
SECOND_LAYER=$(jq -r '.[0].Layers[2]' ${TMP}/manifest.json)
tar xf ${TMP}/${SECOND_LAYER} -C $(dirname ${TMP}/${SECOND_LAYER})
SECOND_FLAG=$(cat $(dirname ${TMP}/${SECOND_LAYER})/chal/p-flag.txt)
# Find the first part of flag in the redundant echo command in the history.
jq -r '.history[4].created_by' ${TMP}/acbb216b17482071caca135101282177f6ffed7b8ee0bfc5323aae103c216d74.json | \
    sed -e 's/> \/dev\/null//' -e 's/\/bin\/sh -c echo //' -e 's/"//g' -e 's/ //g' > ${TMP}/first.txt
FIRST_FLAG=$(base64 -d ${TMP}/first.txt)
# Print the flag
echo ${FIRST_FLAG}${SECOND_FLAG}
```
