user "my_site" do
    comment "my_site user"
    home "/home/my_site"
    shell "/bin/bash"
    supports  :manage_home => true
end
 
directory "/var/www/html/my_site" do
    owner "my_site"
    group "my_site"
    mode 0755
    action :create
end
 
template "/var/www/html/my_site/index.html" do
    source "message.erb"
    variables(
        :message => "Hello World!"
    )
    user "my_site"
    group "my_site"
    mode 0755
end
 
web_app "my_site" do
    server_name node['hostname']
    server_aliases [node['fqdn'], "my-site.example.com"]
    docroot "/var/www/html/my_site/html"
    cookbook 'apache2'
end 
