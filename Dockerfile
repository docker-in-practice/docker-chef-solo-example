FROM ubuntu:14.04

RUN apt-get update && apt-get install -y git curl

RUN curl -L https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.3.5-1_amd64.deb -o chef.deb
RUN dpkg -i chef.deb
RUN rm chef.deb

RUN mkdir -p /chef/cookbooks/example/recipes cookbooks/example/templates/default /var/log/chef

COPY /cookbooks/example/recipes/default.rb /chef/cookbooks/example/recipes/default.rb
COPY /cookbooks/example/templates/default/message.erb /chef/cookbooks/example/templates/default/message.erb

WORKDIR /chef/cookbooks
RUN knife cookbook site download apache2 
RUN knife cookbook site download iptables
RUN knife cookbook site download logrotate

RUN /bin/bash -c 'for f in $(ls *gz); do tar -zxf $f; done'
RUN /bin/bash -c 'rm *gz'

COPY /config.rb /chef/
COPY /attributes.json /chef/

RUN chef-solo -c /chef/config.rb -j /chef/attributes.json

#USER example
WORKDIR /home/example

CMD ["/bin/bash"]
