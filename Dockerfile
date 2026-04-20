# Stage 1: Base image for building and development
FROM python:3.11-slim AS base

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Install system dependencies
# git is often required by some MkDocs plugins (like git-revision-date)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Stage 2: Development environment
FROM base AS development
EXPOSE 8000
# We use --dev-addr 0.0.0.0:8000 so it can be accessed from outside the container
CMD ["mkdocs", "serve", "--dev-addr", "0.0.0.0:8000"]

# Stage 3: Build static site
FROM base AS builder
RUN mkdocs build

# Stage 4: Production environment (Nginx)
FROM nginx:alpine AS production
# Copy built site from builder stage to Nginx html directory
COPY --from=builder /app/site /usr/share/nginx/html
# Expose port 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
