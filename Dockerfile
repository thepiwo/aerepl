FROM erlang:21

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt-get -y update && \
    apt-get install -y curl cmake g++ pkg-config git vim-common libwebsockets-dev libjson-c-dev libssl-dev && \
    git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && cmake .. && make && make install && \
    curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz && \
    tar -xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16 && \
    ./configure && make && make install && ldconfig && \
    apt-get purge -y curl cmake pkg-config vim-common libwebsockets-dev libjson-c-dev libssl-dev && \
    apt-get clean

EXPOSE 7681

WORKDIR /repl
COPY . /repl

RUN ./rebar3 compile

ENTRYPOINT ["ttyd"]
CMD ["./rebar3", "shell"]
