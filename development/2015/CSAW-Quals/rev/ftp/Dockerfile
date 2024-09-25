FROM ubuntu:latest
LABEL Description="CSAW 2015-Q: FTP" VERSION='1.0'
# Files
RUN mkdir -p /root/ftp
ADD ftp /root/ftp
ADD re_solution.txt /root/ftp
WORKDIR /root/ftp
RUN chmod 750 ./ftp
# Execute
ENTRYPOINT ["./ftp"]
EXPOSE 12012
