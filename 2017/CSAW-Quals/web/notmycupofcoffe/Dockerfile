FROM tomcat:9.0

RUN rm -rf $CATALINA_HOME/webapps/*
COPY ./target/coffee $CATALINA_HOME/webapps/ROOT


ENV flag $(cat flag.txt)
COPY flag.txt $CATALINA_HOME/flag.txt
RUN echo "export flag=\"$(cat $CATALINA_HOME/flag.txt)\"" > $CATALINA_HOME/bin/setenv.sh
RUN chmod +x $CATALINA_HOME/bin/setenv.sh
