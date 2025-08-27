FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    build-essential gcc g++ git \
    libelf-dev flex bison bc \
    libmpc-dev libfmt-dev \
    python3 python3-pip python3-setuptools \
    rsync cpio curl file wget unzip

# Needed for buildroot
RUN apt-get install -y rsync cpio
RUN mkdir /home/randcompile /home/randcompile/kernels /home/randcompile/source
RUN apt-get install -y libssl-dev
# Checkout an unmodified 5.15.63 kernel.
# Getting it from Git should work for quite a while. If this faults at some day, 5.15 is an LTS release. It should be possible to obtain it from an alternative source... 
RUN git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git --depth 1 --branch v5.15.63 /home/randcompile/source

COPY randfun.patch build-kernel.sh config-base config-buildroot /home/randcompile/
COPY buildroot-overlay/ home/randcompile/buildroot-overlay/
RUN cp -r /home/randcompile/source /home/randcompile/source-unpatched
WORKDIR /home/randcompile/source

# Apply our patch
RUN patch -p1 < ../randfun.patch

WORKDIR /home/randcompile/
ENTRYPOINT ["/home/randcompile/build-kernel.sh"]
