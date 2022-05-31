FROM gradle:6.9.2-jdk8 as builder
COPY ./app /app
WORKDIR /app
RUN ls && gradle build
FROM dockerhub/library/tomcat:jdk11
RUN ["rm", "-rf", "/usr/local/tomcat/webapps/ROOT"]
COPY --from=builder /app/build/libs/*.jar /usr/local/tomcat/webapps/ROOT.jar
CMD ["java","-jar","/usr/local/tomcat/webapps/ROOT.jar"]
