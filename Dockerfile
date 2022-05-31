# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git clang cmake make

## Install json-parser as a pre-requisite for header file inclusion
WORKDIR /
RUN git clone https://github.com/json-parser/json-parser.git
WORKDIR /json-parser
RUN ./configure && make -j$(nproc) && make install
RUN ldconfig

## Add source code to the build stage.
WORKDIR /
ADD https://api.github.com/repos/capuanob/json-builder/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/capuanob/json-builder.git
WORKDIR json-builder

## Build
RUN cmake . -DCMAKE_C_COMPILER=clang -DBUILD_FUZZER=1
RUN make

## Consolidate all dynamic libraries used by the fuzzer
RUN mkdir /deps
RUN cp `ldd fuzz/json-builder-fuzzer | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :
#
### Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /json-builder/fuzz/json-builder-fuzzer /json-builder-fuzzer
COPY --from=builder /deps /usr/lib
#
### Set up fuzzing!
ENTRYPOINT []
CMD /json-builder-fuzzer -close_fd_mask=2
