FROM fedora:30
ENV VVV=/usr/local/docker
ENV VER=19.3
ENV LOG=/root/.kerl/builds/${VER}_halfword/otp_build_${VER}.log

ADD kerl /usr/bin/kerl
RUN dnf install -y gcc tar make perl ncurses-devel openssl-devel patch unzip git automake autoconf procps-ng openssl-devel ncurses-devel gcc
RUN (mkdir -p $VVV; \
     kerl list releases; \
     env KERL_CONFIGURE_OPTIONS=--enable-halfword-emulator kerl build $VER ${VER}_halfword; true)
RUN (touch ${LOG}; cat ${LOG})
RUN kerl install ${VER}_halfword $VVV/erl.${VER}

ADD startservice.sh /usr/local/startservice.sh


EXPOSE 22
CMD ["/usr/local/startservice.sh"]

