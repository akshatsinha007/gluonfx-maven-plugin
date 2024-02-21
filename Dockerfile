FROM maven:3.6.3-openjdk-17-slim AS builder

WORKDIR /app

# Copy only the POM file
COPY pom.xml .

COPY settings.xml /tmp/settings.xml

# Copy the app code
COPY src/ ./src/

# Download dependencies  -s /tmp/settings.xml 
RUN mvn -s /tmp/settings.xml clean install -U

# Build app skip tests -s /tmp/settings.xml 
RUN mvn -s /tmp/settings.xml package -DskipTests -U

# Create new image actual runtime
FROM openjdk:8-jdk-alpine

WORKDIR /

# Copy the JAR file from the builder image
COPY --from=builder /app/target/gluonfx-maven-plugin-1.0.23-SNAPSHOT.jar /gluonfx-maven-plugin-1.0.23-SNAPSHOT.jar

CMD ["java", "-jar", "gluonfx-maven-plugin-1.0.23-SNAPSHOT.jar"]
