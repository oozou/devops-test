# Build stage
## hardened-alpine image was built from docker/hardened-docker-base/Dockerfile
ARG IMAGE_ALPINE=hardened-alpine 
FROM $IMAGE_ALPINE AS build
# Install dumb-init
## signal handling to processes which run as PID 1.
## to prevent creation of zombie processes and orphan processes.
RUN apk add --update dumb-init && rm -rf /var/cache/apk/*

COPY package*.json .
RUN npm ci --only=production && \
   rm -f .npmrc

# Production stage
FROM $IMAGE_ALPINE
# support multiple environments (DEV, UAT & Production)
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --chown=app:app --from=build /app/node_modules /app/node_modules
COPY --chown=app:app . /app
USER app

CMD ["dumb-init", "node", "index.js"]
