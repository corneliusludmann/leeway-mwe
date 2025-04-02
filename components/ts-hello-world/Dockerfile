FROM node:18-alpine
WORKDIR /app
COPY components-ts-hello-world--app/package*.json ./
RUN npm install --production
COPY components-ts-hello-world--app/dist/ ./dist/
CMD ["node", "dist/index.js"]
