FROM golang:1.10-alpine
RUN apk add --no-cache make git
RUN \
	go get -v github.com/aliyun/aliyun-openapi-meta || true &&\
	go get -v gopkg.in/ini.v1 &&\
	go get -v github.com/droundy/goopt &&\
	go get -v github.com/alyu/configparser &&\
	go get -v github.com/syndtr/goleveldb/leveldb &&\
	go get -v github.com/aliyun/aliyun-oss-go-sdk/oss &&\
	go get -v -u github.com/jteeuwen/go-bindata/... &&\
	go get -v github.com/jmespath/go-jmespath &&\
	go get -v github.com/aliyun/alibaba-cloud-sdk-go/sdk &&\
	go get -v github.com/posener/complete &&\
	go get -v github.com/aliyun/ossutil/lib &&\
    go get -v gopkg.in/yaml.v2
