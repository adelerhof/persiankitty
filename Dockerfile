# builder image
FROM golang:1.15.6-alpine3.12 as builder
RUN mkdir /build
ADD *.go /build/
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -o kitty .


# generate clean, final image for end users
FROM alpine:3
RUN apk --no-cache add ca-certificates
RUN apk update
RUN apk upgrade --available && sync
COPY --from=builder /build/kitty .
COPY White_Persian_Cat.jpg .
COPY index.html .

# executable
ENTRYPOINT [ "./kitty" ]

# http server listens on port 85.
EXPOSE 80