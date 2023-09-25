FROM openjdk:17-ea-11-jdk-slim

VOLUME /tmp

COPY build/libs/bank-service-1.0.jar BankServer.jar

ENTRYPOINT ["java", "-jar", "BankServer.jar"]

