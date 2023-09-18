FROM ubuntu:20.04 As builder

RUN apt-get update && apt-get install -y dos2unix openjdk-17-jdk

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

RUN chmod +x gradlew
RUN dos2unix gradlew
RUN ./gradlew bootJar

FROM openjdk:17
COPY --from=builder build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
