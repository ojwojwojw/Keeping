FROM openjdk:17-ea-11-jdk-slim

VOLUME /tmp

COPY build/libs/mission-service-1.0.jar MissionServer.jar

ENTRYPOINT ["java", "-jar", "MissionServer.jar"]
