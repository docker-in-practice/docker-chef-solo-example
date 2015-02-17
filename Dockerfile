FROM ubuntu:14.04

RUN apt-get update && apt-get install -y git curl

RUN	curl -L https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.3.5-1_amd64.deb -o chef.deb
RUN dpkg -i chef.deb
RUN rm chef.deb

RUN mkdir -p /app/src /app/src_runtime /meta /var/log/chef /chef

# From: http://www.dmuth.org/node/1397/chef-101-introduction-chef
RUN mkdir -p /chef/cookbooks/hello/recipes
RUN touch /chef/cookbooks/hello/recipes/default.rb

COPY /config.rb /chef/
COPY /attributes.json /chef/

RUN chef-solo -c /chef/config.rb -j /chef/attributes.json

CMD ["/bin/bash"]
