FROM alpine

WORKDIR /chal

COPY p-flag.txt p-flag.txt

RUN echo "ZmxhZ3tuM3Yzcl9sMzR2M181M241MTcxdjNfMW5mMHJtNDcxMG5fdW5wcjA=" > /dev/null

RUN cat p-flag.txt > tmp.txt; rm -rf flag.txt p-flag.txt; mv tmp.txt flag.txt; echo "" >> flag.txt

RUN echo "Find the rest of the flag by yourself!" >> flag.txt

CMD ["/bin/sh"] 
