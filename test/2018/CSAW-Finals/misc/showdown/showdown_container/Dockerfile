FROM ubuntu:18.04

RUN apt update
RUN apt install -y sudo

RUN adduser --disabled-password --uid 1000 cowhand
RUN adduser --disabled-password --uid 1001 bandit
RUN usermod -a -G sudo bandit

ADD --chown=root:root sudoers /etc/sudoers
ADD --chown=bandit:bandit bandit.sh /home/bandit/bandit.sh
RUN touch /home/bandit/.sudo_as_admin_successful && chown bandit:bandit /home/bandit/.sudo_as_admin_successful

ENTRYPOINT ["su", "-l", "-s", "/home/bandit/bandit.sh", "bandit"]
