FROM gradle:jdk8 as builder
COPY ./app /app
WORKDIR /app
RUN which gradle
RUN ls -al /usr/bin/gradle
RUN echo $JAVA_HOME
RUN ls && gradle build
FROM dockerhub/library/tomcat:jdk11
RUN ["rm", "-rf", "/usr/local/tomcat/webapps/ROOT"]
COPY --from=builder /app/build/libs/*.jar /usr/local/tomcat/webapps/ROOT.jar
CMD ["java","-jar","/usr/local/tomcat/webapps/ROOT.jar"]
