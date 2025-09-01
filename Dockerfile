FROM golang:1.19.5-alpine as builder
ENV CGO_ENABLED=0
RUN apk add --no-cache git

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# build the server
RUN go build -o peer-calls .

FROM alpine:3.17
WORKDIR /app
COPY --from=builder /app/peer-calls /usr/local/bin/

# Render sets $PORT dynamically
ENV PORT=10000
EXPOSE 10000

CMD ["/usr/local/bin/peer-calls", "-bind", "0.0.0.0:$PORT", "-network-type", "sfu"]
