from sagemath/sagemath

RUN sudo apt-get update
RUN sudo apt-get install -y socat

WORKDIR /home/sage

COPY secret.py .
COPY challenge.py .

EXPOSE 3788
USER sage
CMD mkdir .sage && chmod 700 -R .sage
CMD "socat -T90 tcp-listen:3788,reuseaddr,fork exec:\"python -u /home/sage/challenge.py\""
