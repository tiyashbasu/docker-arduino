FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
    libfontconfig1 \
    libxrender1 \
    libxi6 \
    libxtst6 \
    xz-utils \
    libjssc-java \
    wget

ARG version
ARG system

ENV DISPLAY :0
ENV JAVA_TOOL_OPTIONS ""

RUN adduser --quiet --disabled-password --uid 1000 arduino
RUN gpasswd -a arduino uucp

WORKDIR /home/arduino/

USER 1000:987

RUN wget https://downloads.arduino.cc/arduino-${version}-${system}.tar.xz
RUN tar xf arduino-${version}-${system}.tar.xz
RUN rm arduino-${version}-${system}.tar.xz

WORKDIR arduino-${version}

# The following two lines are there two correct a bug with JAVA_OPTIONS
RUN sed -i "0,/\(JAVA_OPTIONS.*\)/s//# \1/" arduino
RUN sed -i 's/\("${JAVA_OPTIONS.*}" \)//' arduino

RUN ./arduino --install-boards arduino:sam
RUN ./arduino --install-boards arduino:avr

CMD ./arduino
