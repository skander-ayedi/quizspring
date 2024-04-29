FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled jar file from the build stage to the runtime image
COPY target/*.jar app.jar

# Expose the port that the application runs on
EXPOSE 8080

# Specify the command to run the application
CMD ["java", "-jar", "app.jar"]
