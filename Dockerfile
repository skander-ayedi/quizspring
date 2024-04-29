# Use a base image with OpenJDK 11 installed
FROM openjdk:11-jdk-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven wrapper and the project's pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x mvnw

# Copy the project source code
COPY src src

# Build the application
RUN ./mvnw clean package -Dmaven.test.skip=true

# Use a lighter base image for the runtime
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled jar file from the build stage to the runtime image
COPY --from=build /app/target/*.jar app.jar

# Expose the port that the application runs on
EXPOSE 8080

# Specify the command to run the application
CMD ["java", "-jar", "app.jar"]
