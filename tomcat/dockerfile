FROM tomcat:9.0

ENV TZ=Asia/Seoul
ENV CATALINA_HOME /usr/local/tomcat
# JAVA_HOME 환경 변수 설정 (OpenJDK 설치 경로)
ENV JAVA_HOME /opt/java/openjdk

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN rm -Rf /usr/local/tomcat/webapps
RUN mkdir -p /usr/local/tomcat/webapps/ROOT
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/image
RUN mkdir -p /usr/local/tomcat/webapps/images
RUN mkdir -p /usr/local/tomcat/webapps/video
COPY ./mysql-connector-j-8.0.33.jar /usr/local/tomcat/lib/.
COPY ./image/*.* /usr/local/tomcat/webapps/ROOT/image
COPY ./*.* /usr/local/tomcat/webapps/ROOT/.
COPY server.xml /usr/local/tomcat/conf/.
RUN rm -f /usr/local/tomcat/webapps/ROOT/mysql-connector-j-8.0.33.jar
COPY tomcat /etc/default/.

# 필요한 포트 노출
EXPOSE 8080

# Tomcat 시작 명령어
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]