# ---------- Build Stage ----------
FROM node:18-alpine AS builder
WORKDIR /app

# Copy only the package files 
COPY package*.json ./

# Install dependencies 
RUN npm ci --only=production

# Copy the rest of the application source code
COPY . .

# ---------- Production Stage ----------
FROM node:18-alpine
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

# Copy only necessary files from the build stage
COPY --from=builder /app /app

# Ensure the app directory is owned by the non-root user
RUN chown -R nodejs:nodejs /app

# Switch to the non-root user
USER nodejs

# Expose the app port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
