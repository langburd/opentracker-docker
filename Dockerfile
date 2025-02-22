FROM alpine:3.21.3 AS builder

# hadolint ignore=DL3018
RUN apk add --no-cache \
	gcc \
	g++ \
	make \
	git \
	cvs \
	zlib-dev

WORKDIR /build

RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat
WORKDIR /build/libowfat
RUN make

WORKDIR /build

RUN git clone git://erdgeist.org/opentracker
WORKDIR /build/opentracker
RUN make

FROM alpine:3.21.3

LABEL maintainer="Avi Langburd <avi@langburd.com>"

COPY --from=builder /build/opentracker/opentracker /usr/local/bin/opentracker

COPY . /etc/opentracker/

EXPOSE 6969

CMD ["opentracker", "-f", "/etc/opentracker/opentracker.conf"]
