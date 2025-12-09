# syntax=docker/dockerfile:1

# ---- 1. Extraction Stage (No Gradle needed!) ----
# We use a JRE just to run the "extract" command on the JAR you already built
FROM eclipse-temurin:17-jre-alpine AS builder
WORKDIR /builder

# ARG: Pass the jar location (we will set this in Nx)
ARG JAR_FILE=apps/backend-demo/build/libs/*-SNAPSHOT.jar

# Copy the JAR from your Host machine (GitHub Actions / Laptop) into the container
COPY ${JAR_FILE} app.jar

# Extract layers (This takes 0.5 seconds)
RUN java -Djarmode=layertools -jar app.jar extract

# ---- 2. Runtime Stage ----
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the layers we just extracted
COPY --from=builder /builder/dependencies/ ./
COPY --from=builder /builder/spring-boot-loader/ ./
COPY --from=builder /builder/snapshot-dependencies/ ./
COPY --from=builder /builder/application/ ./

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
