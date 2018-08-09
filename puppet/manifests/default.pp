# Base to apply on all nodes
node default {
  include base
}

node /observium/ {
  include docker
  include observium
}

node /splunk/ {
  include splunk
  include base
}

node /ldap/ {
  include docker
}
