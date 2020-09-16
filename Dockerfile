FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="joinAPIs version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="joinapis"

# environment settings
ENV HOME="/app"
ENV NODE_ENV="production"

RUN \
    echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
        g++ \
        make && \
    echo "**** install runtime packages ****" && \
    apk add --no-cache --upgrade \
        alpine-base \
        curl \
        git \
        nano \
        nodejs-current \
        npm \
        yarn && \
    echo "**** cleanup ****" && \
    apk del --purge build-dependencies && \
    rm -rf /root/.cache /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 4200