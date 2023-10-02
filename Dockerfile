FROM eclipse-temurin:17-jdk-alpine as build
RUN addgroup -S rosa && adduser -S rosa -G rosa
USER rosa
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw install -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
RUN ./mvnw clean package

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
VOLUME /tmp
ARG TARGET=/workspace/app/target
COPY --from=build ${TARGET}/rosa-*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]