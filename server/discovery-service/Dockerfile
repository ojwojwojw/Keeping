FROM openjdk:17-ea-11-jdk-slim

VOLUME /tmp

COPY build/libs/discovery-service-1.0.jar DiscoveryServer.jar

ENTRYPOINT ["java", "-jar", "DiscoveryServer.jar"]