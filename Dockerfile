FROM ubuntu:14.04

RUN apt-get update && apt-get install -y git curl

RUN curl -L https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.3.5-1_amd64.deb -o chef.deb
RUN dpkg -i chef.deb
RUN rm chef.deb

RUN mkdir -p /chef/cookbooks/my_site/recipes /chef/cookbooks/my_site/templates/default /var/log/chef

COPY /cookbooks/my_site/recipes/default.rb /chef/cookbooks/my_site/recipes/default.rb
COPY /cookbooks/my_site/templates/default/message.erb /chef/cookbooks/my_site/templates/default/message.erb

WORKDIR /chef/cookbooks
RUN knife cookbook site download apache2 
RUN knife cookbook site download iptables
RUN knife cookbook site download logrotate

RUN /bin/bash -c 'for f in $(ls *gz); do tar -zxf $f; done'
RUN /bin/bash -c 'rm *gz'

COPY /config.rb /chef/
COPY /attributes.json /chef/

RUN chef-solo -c /chef/config.rb -j /chef/attributes.json

CMD ["/bin/bash"]
