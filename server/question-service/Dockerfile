FROM openjdk:17-ea-11-jdk-slim
VOLUME /tmp
COPY build/libs/question-service-1.0.jar QuestionServer.jar
ENTRYPOINT ["java", "-jar", "QuestionServer.jar"]