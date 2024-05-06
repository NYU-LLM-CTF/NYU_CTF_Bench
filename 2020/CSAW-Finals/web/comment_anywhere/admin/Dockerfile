FROM python:3.7

RUN apt-get update && apt-get install -y xvfb chromium
RUN pip3 install pyppeteer

RUN mkdir /opt/stuff
WORKDIR /opt/stuff

ADD admin/xvfb_admin.sh .
ADD admin/admin_bot.py .
ADD extension ./extension

# Run pyppeteer-install to install chromium
RUN pyppeteer-install

CMD "./xvfb_admin.sh"
