#BYOCF (bring your own config file)

Different deployments of this app will need to configure database.yaml differently. Specifically, user's developing on c9.io won't be able to store environment variables and thus need to configure for a mysql user with no password. Here is an example of this config file.

_TODO: need an example of a working database.yml file from c9 here_