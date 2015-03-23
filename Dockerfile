FROM nginx:latest

RUN export CT_VERSION=0.7.0 && \
    export DEBIAN_FRONTEND=noninteractive && \
    touch /etc/inittab && \
    apt-get update && \
    apt-get install -y --no-install-recommends runit curl && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
# configure nginx
    rm -f /etc/nginx/sites-enabled/default && \
    rm -f /etc/nginx/conf.d/default.conf && \
    rm -f /etc/nginx/conf.d/example_ssl.conf && \
# configure consul-template
    curl -qL https://github.com/hashicorp/consul-template/releases/download/v${CT_VERSION}/consul-template_${CT_VERSION}_linux_amd64.tar.gz \
    | tar -C /usr/local/bin --strip-components 1 -zxf - && \
    chmod +x /usr/local/bin/consul-template

ADD consul-template.service /etc/service/consul-template/run
ADD nginx.service /etc/service/nginx/run

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]

ONBUILD ADD templates/ /etc/consul-template/templates/
ONBUILD ADD config /etc/consul-template/config/

EXPOSE 80 443
