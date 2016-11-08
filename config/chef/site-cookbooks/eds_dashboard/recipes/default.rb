# Recipe::default
# Initial set up for Ubuntu 16.04


# update package database
execute "apt-get update"

# install packages
package "telnet"
package "postfix"
package "curl"
package "git-core"
package "zlib1g-dev"
package "libssl-dev"
package "libreadline-dev"
package "libyaml-dev"
package "libsqlite3-dev"
package "sqlite3"
package "libxml2-dev"
package "libxslt1-dev"
package "libcurl4-openssl-dev"
package "python-software-properties"
package "libpq-dev"
package "libffi-dev"
package "build-essential"
package "tree"

# set timezone
bash "set timezone" do
code <<-EOH
  echo 'America/New_York' > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
EOH
not_if "date | grep -q 'EDT\|EST'"  # don't run if a timezone is properly set
end
