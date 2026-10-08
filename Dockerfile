# ---- Stage 1: Build ----
FROM maven:3.9-eclipse-temurin-26 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests -B

# ---- Stage 2: Run ----
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only the built JAR from stage 1
COPY --from=build /app/target/*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

USER appuser
EXPOSE 8080

# Health check against Spring Actuator
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]