FROM rockylinux:8
ENV VVV=/usr/local/docker
ENV VER=25.0
ENV LOG=/root/.kerl/builds/${VER}_halfword/otp_build_${VER}.log

ADD kerl /usr/bin/kerl
RUN yum install -y gcc tar make perl ncurses-devel openssl-devel patch unzip git automake autoconf
RUN yum install -y gcc-toolset-11-gcc-c++
RUN scl list-collections
RUN echo '. /opt/rh/gcc-toolset-11/enable' >> ~/.bashrc
RUN source ~/.bashrc
RUN (mkdir -p $VVV; \
     . /opt/rh/gcc-toolset-11/enable; \
     kerl update releases; \
     type gcc; type g++; \
     env KERL_CONFIGURE_OPTIONS=--enable-halfword-emulator kerl build $VER ${VER}_halfword; true)
RUN (touch ${LOG}; cat ${LOG})
RUN kerl install ${VER}_halfword $VVV/erl.${VER}

ADD startservice.sh /usr/local/startservice.sh


EXPOSE 22
CMD ["/usr/local/startservice.sh"]

