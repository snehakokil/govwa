FROM golang:latest

RUN go env
RUN cd /go/src/
RUN go get github.com/go-sql-driver/mysql
RUN go get github.com/gorilla/sessions
RUN go get github.com/julienschmidt/httprouter
RUN go run app.go

EXPOSE 8082
