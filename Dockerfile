# Use the official OpenJDK image with Java 21 as a base image for the build stage
FROM openjdk:21-jdk-slim AS build

# Install Maven (you can also specify a specific version here)
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz && \
    tar -xvzf apache-maven-3.8.4-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.4/bin/mvn /usr/bin/mvn

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY . .

# Build the application using Maven
RUN mvn clean package -Dmaven.test.skip=true

# Use the official OpenJDK image with Java 21 as a base image for the runtime stage
FROM openjdk:21-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar oorvasi.jar

# Command to run the JAR file
CMD ["java", "-jar", "oorvasi.jar"]
