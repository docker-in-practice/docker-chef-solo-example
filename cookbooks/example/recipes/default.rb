# Create a user.
user "example" do
    comment "Example User"
    home "/home/example"
    shell "/bin/bash"
    supports  :manage_home => true
end
 
# When executing a script, it should create a file specified by 
# "creates" upon completion. This ensures that the command will 
# only run once throughout the life of the system.
execute "a sample command" do
    command "touch /home/example/sample.txt"
    creates "/home/example/sample.txt"
end
 
# Create a directory with specified ownership and permissions.
directory "/home/example/example-app" do
    owner "example"
    group "example"
    mode 0755
    action :create
end
 
 
# Create a configuration file based on a template.
# This will only run if the date of the template file is newer than the date 
# of the deployed file. 
template "/home/example/example-app/config.json" do
    source "message.erb"
    variables(
        :message => "Hello World!"
    )
    user "example"
    group "example"
    mode 0600
end
 
 
