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
ADD . /json-builder
WORKDIR /json-builder

## Build
RUN cmake . -DCMAKE_C_COMPILER=clang -DBUILD_FUZZER=1
RUN make

### Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /json-builder/fuzz/json-builder-fuzzer /json-builder-fuzzer
#
### Set up fuzzing!
ENTRYPOINT []
CMD /json-builder-fuzzer
