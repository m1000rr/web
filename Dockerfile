FROM node:22-alpine as deps

WORKDIR /opt/m1000rr

COPY package.json yarn.lock ./

RUN yarn install \
  --prefer-offline \
  --frozen-lockfile \
  --non-interactive \
  --production=false

FROM node:22-alpine as builder

WORKDIR /opt/m1000rr

COPY --from=deps /opt/m1000rr/node_modules ./node_modules
COPY . .

RUN yarn build

FROM node:22-alpine

WORKDIR /opt/m1000rr

COPY --from=builder /opt/m1000rr/.output  .

ENV HOST 0.0.0.0
EXPOSE 3000

CMD [ "node", "server/index.mjs" ]