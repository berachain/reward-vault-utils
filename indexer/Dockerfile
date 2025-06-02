FROM node:20-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm@10.11.0

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy prisma schema
COPY prisma ./prisma/

# Generate Prisma client
RUN pnpm prisma generate

# Copy source code and config files
COPY src ./src/
COPY tsconfig.json ./
COPY abis ./abis/

# Build the application
RUN pnpm build

# Expose the port
EXPOSE 3000

# Start the application
CMD ["pnpm", "run", "start:dev"] 