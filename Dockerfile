FROM tomcat:8.0
ADD /setenv.sh /usr/local/tomcat/bin/setenv.sh
EXPOSE 8080
