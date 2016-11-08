# variables for node.js
arch = node['kernel']['machine'] =~ /x86_64/ ? "x64" : "x86"
package_stub = "node-v#{node['nodejs']['version']}-linux-#{arch}"
nodejs_tar = "#{package_stub}.tar.gz"
nodejs_url = "http://nodejs.org/dist/v#{node['nodejs']['version']}/#{nodejs_tar}"
executable = "#{node['nodejs']['dir']}/bin/node"

# download tar file
remote_file "/usr/local/src/#{nodejs_tar}" do
  source nodejs_url
  mode 0644
  action :create_if_missing
end

# install node.js from binaries
execute "install node.js" do
  command <<-EOF
    tar xf /usr/local/src/#{nodejs_tar} \
    --strip-components=1 --no-same-owner \
    -C #{node['nodejs']['dir']} \
    #{package_stub}/bin \
    #{package_stub}/lib \
    #{package_stub}/share
  EOF
  not_if { File.exists?(executable) && `#{node['nodejs']['dir']}/bin/node --version`.chomp == "v#{node['nodejs']['version']}" }
end
