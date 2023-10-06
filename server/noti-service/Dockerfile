FROM openjdk:17-ea-11-jdk-slim
VOLUME /tmp
COPY build/libs/noti-service-1.0.jar NotiServer.jar
ENTRYPOINT ["java", "-jar", "NotiServer.jar"]