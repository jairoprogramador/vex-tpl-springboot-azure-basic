FROM maven:3.9.9-eclipse-temurin-17-alpine AS builder

#RUN apk add --no-cache maven

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

RUN mkdir -p /app && chown -R appuser:appgroup /app

WORKDIR /app

USER appuser

COPY --chown=appuser:appgroup pom.xml ./
COPY --chown=appuser:appgroup src ./src

RUN mvn clean package -DskipTests=true

FROM eclipse-temurin:17-jre-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

RUN mkdir -p /app && chown -R appuser:appgroup /app

WORKDIR /app

USER appuser

COPY --chown=appuser:appgroup --from=builder /app/target/*.jar app.jar

ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Xmx512m -Xms256m"

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]