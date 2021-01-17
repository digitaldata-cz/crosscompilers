FROM ubuntu:20.10
ARG GOVERSION=1.16beta1
ARG NODEVERSION=14.x
ARG DEBIAN_FRONTEND=noninteractive
RUN case "$(uname -m)" in \
    "x86_64") \
        ARCH=amd64 ;;\
    "aarch64") \
        ARCH=arm64 ;;\
    "armv8") \
        ARCH=arm64 ;;\
    *) \
        echo "Unsupported CPU architecture" ;\
        exit 1 ;;\
    esac && \
    apt update &&\
    apt upgrade -y &&\
    apt install -y curl &&\
    apt update &&\
    apt install -y \
        make \
        patch \
        git \
        gcc \
        gcc-10-multilib-i686-linux-gnu \
        gcc-10-multilib-x86-64-linux-gnu \
        gcc-10-multilib-arm-linux-gnueabihf \
        gcc-mingw-w64-x86-64 \
        gcc-mingw-w64-i686 &&\
    curl -sL "https://deb.nodesource.com/setup_${NODEVERSION}" | bash - &&\
    apt install -y \
        nodejs \
        yarn &&\
    curl -sL "https://golang.org/dl/go${GOVERSION}.linux-${ARCH}.tar.gz" | tar xzf - -C / && \
    echo "export PATH=$PATH;/go/bin" > /etc/profile.d/golang.sh &&\
    rm -rf /var/lib/apt/lists/*
CMD /bin/bash