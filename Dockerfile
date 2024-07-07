# Maven build container 

FROM maven:3.8.5-openjdk-17 AS maven_build


# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .

# Download the dependencies and build the project
RUN mvn dependency:go-offline

# Copy the entire project
COPY src ./src

# Build the project
RUN mvn package -DskipTests

# Use the official OpenJDK image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built jar file from the build stage
COPY --from=maven_build /app/target/SpringBootRestfulPostJSON-0.0.1-SNAPSHOT.jar  app.jar

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]