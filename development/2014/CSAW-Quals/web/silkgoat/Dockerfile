FROM python:2.7-alpine
MAINTAINER Steven
LABEL Description="CSAW 2014-Q: Silkgoat" VERSION='1.0'
# Update
RUN mkdir -p /root/silkgoat
RUN apk update && apk --no-cache add \
		python-dev zlib-dev jpeg-dev \
		build-base freetype-dev lcms2-dev \
		openjpeg-dev tiff-dev tk-dev \
		tcl-dev harfbuzz-dev fribidi-dev
# Files
WORKDIR /root/silkgoat
COPY server.py .
COPY static/ ./static/
COPY templates/ ./templates/
COPY arial.ttf .
RUN pip install flask simplekv Flask-KVSession pillow
# Execute
EXPOSE 5000
CMD ["python", "server.py"]
