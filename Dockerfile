FROM p2pmoney/ethereum_webapp_svc:0.40.29

MAINTAINER P2PMoney <p2pmoney@p2pventure.org>

# to build a specific combination of releases
# replace master by the tag of the corresponding
# release (e.g. 0.11.0) then build image with
# a specific tag (e.g. "docker build -t primusfinance/myvc_svc:0.11.0")
#ARG did_web_registries_svc_tag=0.11.0
ARG did_web_registries_svc_tag=0.40.43


#	
# DidWebRegistries services
#

# run npm install
# (--unsafe-perm because of "gyp WARN EACCES attempting to reinstall using temporary dev dir")
RUN git clone https://github.com/p2pmoney-org/did_web_registries_svc /tmp/did_web_registries_svc --branch $did_web_registries_svc_tag && \
	cp -R /tmp/did_web_registries_svc/* /home/root/usr/local/ethereum_webapp && \
	cd /home/root/usr/local/ethereum_webapp  && \
	rm -rf /home/root/usr/local/ethereum_webapp/node_modules && \
	npm install --unsafe-perm 

# overload nginx.conf
COPY ./root/etc/nginx/nginx.conf /home/root/setup/appuser/etc/nginx/nginx.conf

# overload setup-container-starter.sh
COPY ./root/setup/setup-container-starter.sh /home/root/setup
RUN chmod 775 /home/root/setup/setup-container-starter.sh

# CMD start command
CMD /home/root/bin/start-pod.sh
