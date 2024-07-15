FROM golang:1.22 as builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build the send.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /send send.go

# Build the read.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /read read.go

FROM alpine:latest
RUN apk update && apk add bash
WORKDIR /

# Copy the main application
COPY --from=builder /send .

# Copy the read executable
COPY --from=builder /read .