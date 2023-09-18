FROM openjdk:17

COPY gradlew .
COPY gradle gradle
COPY build.gradle
COPY settings.gradle .
COPY src src

RUN chome +x ./gradlew
RUN ./gradlew bootjar

FROM openjdk:17
COPY --from=builder build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]