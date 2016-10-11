FROM ubuntu:xenial

RUN mkdir /ripper && mkdir /ripper/source-code

RUN apt update
RUN apt upgrade -y

RUN apt install software-properties-common python-software-properties -y --no-install-recommends
RUN apt-add-repository multiverse
RUN apt update

RUN apt install build-essential automake autoconf wget -y --no-install-recommends
RUN apt install lame libffi-dev libffi-dev libssl-dev flac libav-tools faac libfdk-aac-dev vorbis-tools opus-tools \
        -y --no-install-recommends

RUN apt install python-dev python-pip -y --no-install-recommends

RUN wget https://github.com/nu774/fdkaac/archive/v0.6.2.tar.gz && tar xvf v0.6.2.tar.gz
RUN cd fdkaac-0.6.2 && autoreconf -i && ./configure && make install

# Install libspotify
RUN wget https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-x86_64-release.tar.gz && tar xvf libspotify-12.1.51-Linux-x86_64-release.tar.gz
RUN cd libspotify-12.1.51-Linux-x86_64-release/ && make install prefix=/usr/local

WORKDIR /ripper/source-code
RUN pip install setuptools wheel
COPY requirements.txt /ripper/source-code
RUN pip install -r requirements.txt

COPY spotify_ripper /ripper/source-code/spotify_ripper
COPY setup.py /ripper/source-code/
COPY README.rst /ripper/source-code/
COPY docker_config/* /ripper/source-code/
RUN pip install .

#VOLUME docker_config:/ripper/config

#ENTRYPOINT spotify-ripper -S /ripper/config -k /ripper/config/spotify_appkey.key -u morgaroth -p  spotify:user:morgaroth:playlist:4Usjw07BWhqCgRkMiFQmb7
RUN echo "spotify-ripper -S /ripper/config -k /ripper/config/spotify_appkey.key -u morgaroth -p  spotify:user:morgaroth:playlist:4Usjw07BWhqCgRkMiFQmb7" >> ~/.bash_history
ENTRYPOINT bash