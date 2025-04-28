# Start with a Rust base image based on Bullseye
FROM rust:1.86-bullseye AS builder

# Create a new empty shell project
WORKDIR /usr/src/app
COPY google-scholar-rss-feed .

# Build the application with cargo
RUN cargo build --release

CMD ["bash"]

# Create a new stage with a minimal image
FROM debian:bullseye-slim

# Install dependencies required at runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the built executable from the builder stage
COPY --from=builder /usr/src/app/target/release/google-scholar-rss-feed /usr/local/bin/google-scholar-rss-feed

# Set the startup command
CMD ["google-scholar-rss-feed", "0.0.0.0:3005"]