# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM gradle:8.10.2-jdk17 AS build
WORKDIR /workspace

# Copy Gradle wrapper and config from app directory
COPY apps/backend-demo/gradlew gradlew
COPY apps/backend-demo/gradle gradle
RUN chmod +x gradlew

# Copy backend Gradle files for better caching
COPY apps/backend-demo/build.gradle apps/backend-demo/build.gradle
COPY apps/backend-demo/settings.gradle apps/backend-demo/settings.gradle

# Copy backend sources
COPY apps/backend-demo/ apps/backend-demo/

# Build the application (skip tests)
WORKDIR /workspace/apps/backend-demo
RUN ../../gradlew clean bootJar -x test

# ---- Runtime stage ----
FROM eclipse-temurin:17-jre-alpine
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0" \
    SPRING_PROFILES_ACTIVE=prod
WORKDIR /app

# Copy built jar
COPY --from=build /workspace/apps/backend-demo/build/libs/*.jar /app/app.jar

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "exec java ${JAVA_OPTS} -jar /app/app.jar"]
