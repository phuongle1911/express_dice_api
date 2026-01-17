FROM dhi.io/node:25-debian13-sfw-ent-dev
# Set the working directory of the Docker image
# for everything else to happen in.
WORKDIR /diceapi 
# Copy the repo files into the Docker image in appropriate destinations.
COPY package.json package-lock.json package*.json LICENSE README.md ./
# Install dependencies of the repo before bringing in the source code
# Because of the Docker image layer system, it makes the Docker image building
# faster when we are in dev, because it only rebuilds changed layers!
RUN npm ci

# Layers changed when src/* files change.
# Copy the project source into the Docker image
COPY src ./src/ 
# Set up env variables 
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

ARG JWT_SECRET_KEY=jwtsecretkey01
ENV JWT_SECRET_KEY=${JWT_SECRET_KEY}
# Run the app
CMD ["npm", "start"]
# Expose the app port 
EXPOSE 3000

# Configure a healthcheck 
HEALTHCHECK --interval=30s --retries=3 \
    CMD wget http://localhost:3000/health || exit 1