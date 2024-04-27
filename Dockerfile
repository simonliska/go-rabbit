FROM golang:1.22 as builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /send .

FROM alpine:latest
RUN apk update && apk add bash
WORKDIR /
COPY --from=builder /send .