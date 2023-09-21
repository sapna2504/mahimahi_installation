FROM ubuntu:latest
# here we are using copy . to copy all the files in this folder itself to app directory we have created in the image
RUN apt update
RUN apt install python3 -y
RUN apt update
RUN apt install autoconf -y
RUN apt install pkgconf -y
RUN apt install pkg-config -y
RUN apt install apache2 -y
RUN apt update
RUN apt install git -y
RUN apt install libtool -y
RUN apt update
RUN apt install iptables -y
RUN apt install iproute2 -y
RUN apt install dnsmasq -y
RUN apt install protobuf-compiler -y
RUN apt install apache2-dev -y
RUN apt install libcurl4-openssl-dev libssl-dev -y
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:aguignard/ppa
RUN add-apt-repository --remove ppa:aguignard/ppa
RUN apt update
#RUN apt install xcb-util-xrm -y
RUN apt install libxcb-xrm-dev -y
RUN apt install libxcb-present-dev -y
RUN apt install libpango1.0-dev -y
RUN apt install chromium-browser -y
RUN apt install wget -y
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN pkg -i google-chrome-stable current amd64.deb; apt-get -fy install
RUN apt install snap
#RUN systemctl restart snapd
RUN wget "https://launchpad.net/ubuntu/+archive/primary/+files/snapd_2.37.1_amd64.deb"
RUN dpkg -i ./snapd_2.37.1_amd64.deb
RUN apt-get install -f
RUN snap version
RUN snap install chromium
RUN apt update && apt install -y \ 
  chromium-browser \ 
  chromium-chromedriver
RUN chromium-browser
RUN chromimum-browser --version
RUN git clone https://github.com/ravinet/mahimahi
WORKDIR /mahimahi
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
RUN git clone https://github.com/sapna2504/sapna_docker
RUN git clone https://chromium.googlesource.com/chromium/src
COPY . /app
WORKDIR /app
RUN pwd
RUN python3 test.py





























