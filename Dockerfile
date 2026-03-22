FROM golang:1.22-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /parcel .

FROM alpine:3.19

WORKDIR /app

COPY tracker.db /app/tracker.db
COPY --from=builder /parcel /app/parcel

CMD ["/app/parcel"]
