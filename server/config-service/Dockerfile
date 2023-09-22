#FROM ubuntu:20.04 As builder
#
#RUN apt-get update && apt-get install -y dos2unix openjdk-17-jdk
#
## Set JAVA_HOME environment variable
#ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
#
#VOLUME /tmp
#COPY apiEncryptionKey.jks apiEncryptionKey.jks
#
#COPY gradlew .
#COPY gradle gradle
#COPY build.gradle .
#COPY settings.gradle .
#COPY src src
#
#RUN chmod +x gradlew
#RUN dos2unix gradlew
#RUN ./gradlew bootJar
#
#FROM openjdk:17
#COPY --from=builder build/libs/*.jar ConfigServer.jar
#
#ENTRYPOINT ["java", "-jar", "ConfigServer.jar"]

FROM openjdk:17-ea-11-jdk-slim
VOLUME /tmp
COPY apiEncryptionKey.jks apiEncryptionKey.jks
COPY build/libs/config-service-1.0.jar ConfigServer.jar
ENTRYPOINT ["java", "-jar", "ConfigServer.jar"]