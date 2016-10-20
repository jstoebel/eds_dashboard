# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password node['db']['root_password']
  action [:create, :start]
end

# Add a database user.
execute "create user" do

  sql = %Q(CREATE USER '#{node["db"]["user"]["name"]}'@'localhost'
  IDENTIFIED BY '#{node["db"]["user"]["password"]}'
  GRANT ALL PRIVILEGES ON *.* TO '#{node["db"]["user"]["name"]}'@'localhost'
  )
  command "/usr/bin/mysql -u root -p#{node['db']['root_password']} -D mysql -r -B -N -e #{sql}"

end

# Install the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end
