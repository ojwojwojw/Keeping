# Use the official Flutter image as the base image
FROM cirrusci/flutter:stable

# Set the working directory in the container
WORKDIR /app

# Copy the Flutter project files to the container
COPY . .

# Install dependencies
RUN flutter pub get

# Build the Flutter app
RUN flutter build apk

EXPOSE 3000

CMD ["flutter", "run", "--release"]
