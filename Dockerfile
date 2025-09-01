# ---- Build Go backend only ----
FROM golang:1.19.5-alpine as server

ENV CGO_ENABLED=0

RUN apk add --no-cache git

WORKDIR /src

# Add dependencies
COPY go.mod go.sum ./
RUN go mod download

# Add source and build
COPY . .
RUN go build -o peer-calls .

# ---- Final image ----
FROM alpine:3.17

WORKDIR /app
COPY --from=server /src/peer-calls /usr/local/bin/

# Render expects the app to listen on $PORT
ENV PORT=10000

EXPOSE 10000/tcp
STOPSIGNAL SIGINT

CMD ["/usr/local/bin/peer-calls"]
