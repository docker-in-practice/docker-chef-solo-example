# Create a user.
user "my_site" do
    comment "my_site user"
    home "/home/my_site"
    shell "/bin/bash"
    supports  :manage_home => true
end
 
# Create a directory with specified ownership and permissions.
directory "/usr/share/html" do
    owner "my_site"
    group "my_site"
    mode 0755
    action :create
end
 
 
# Create a configuration file based on a template.
# This will only run if the date of the template file is newer than the date 
# of the deployed file. 
template "/usr/share/html/index.html" do
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
    docroot "/usr/share/html"
    cookbook 'apache2'
end 
