# from node image
FROM node:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN touch /etc/apt/sources.list

RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list

# Handle dependencies
RUN apt-get update && apt-get -y install build-essential git zlib1g-dev \
        genometools \
        tabix \
        xsel \
        && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /soft/bin

ADD ./src/samtools-1.21.tar.bz2 /soft
ADD ./src/htslib-1.21.tar.bz2 /soft

RUN cd /soft/htslib-1.21 && ./configure && make && make install \
        && cd /soft/samtools-1.21 && ./configure --with-htslib=system && make -j4 && make install 

# PATH
ENV PATH=$PATH:/soft/bin

RUN mkdir -p /srv

WORKDIR /srv

COPY index.js .
COPY package.json .
RUN npm install
RUN npm install -g forever
RUN npm install -g @jbrowse/cli
RUN jbrowse create jbrowse2

# Volumes
VOLUME /var/www
VOLUME /data

EXPOSE 8080
CMD NODE_ENV=production forever index.js
#CMD ["node", "index.js"]

