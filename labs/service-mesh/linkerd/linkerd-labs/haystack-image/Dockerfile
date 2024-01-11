# Set up build container
FROM golang:1.21 as build

COPY ./src haystack

WORKDIR haystack

ENV GOOS linux
ENV CGO_ENABLED 0

RUN go build -x -o haystack-binary haystack.go

# Create the minimal runtime image
FROM scratch

EXPOSE 8080
EXPOSE 8081

COPY --from=build --chown=0:0 /go/haystack/haystack-binary /haystack

USER 1001

ENTRYPOINT ["/haystack"]

CMD ["./haystack"]

