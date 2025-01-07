FROM openjdk:17-jdk-slim AS builder

ADD . /src
WORKDIR /src

RUN chmod +x ./mvnw && ./mvnw clean package -DskipTests

FROM openjdk:17-jdk-slim

ARG build=dev
ARG commit=null
ARG ver_pom=null
ARG ver_tag=dev

ENV ENV=$build
ENV COMMIT=$commit
ENV VER_POM=$ver_pom
ENV VER_TAG=$ver_tag

COPY --from=builder /src/target/*.jar /app.jar

COPY --from=builder /src/target/classes/*.properties /
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "exec java -jar app.jar --spring.profiles.active=$ENV --server.port=8080"]
