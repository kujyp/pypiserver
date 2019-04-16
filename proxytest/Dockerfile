FROM centos:centos7

RUN yum install -y \
 epel-release wget \
 && yum install -y \
 nginx \
 && rm -rf /var/cache/yum

RUN curl https://bootstrap.pypa.io/get-pip.py | python

RUN pip install --no-cache-dir \
 passlib==1.7.1

WORKDIR proxytest

EXPOSE 8000
VOLUME ["/data"]

ADD proxytest/nginx.conf /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

ADD . .

CMD nginx \
 && PYTHONPATH='.' python pypiserver/__main__.py --root="/data" --port 8001
