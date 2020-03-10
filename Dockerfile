FROM haamutech/cmake-llvm:latest as build

RUN apt-get install --no-install-recommends -y inotify-tools wget ca-certificates

WORKDIR /app

COPY . .

RUN cd lib/catch2 &&\
    cmake -Bbuild -H. -DBUILD_TESTING=OFF &&\
    cmake --build build/ --target install
