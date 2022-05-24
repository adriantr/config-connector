FROM golang:alpine as build
WORKDIR /build
COPY cmd cmd/
COPY go.mod .
COPY go.sum .
RUN ls cmd
RUN go build -o app ./cmd/

FROM alpine
COPY --from=build /build/app /app
EXPOSE 80
ENTRYPOINT [ "/app" ]
