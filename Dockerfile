FROM tomcat:8.5.41
MAINTAINER karthik
# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat

WORKDIR /usr/local/tomcat

COPY **/*.war /usr/local/tomcat/webapps/

# To Expose port in the container
EXPOSE 2345
CMD ["catalina.sh", "run"]
