FROM node:16.20.2

RUN mkdir node

COPY . ./node

WORKDIR ./node/
# Install npm production packages 
RUN npm install

EXPOSE 3000

CMD ["npm", "start"]