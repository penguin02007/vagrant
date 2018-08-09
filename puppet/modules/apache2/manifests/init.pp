# Deploy reverse proxy for splunk
class splunk {
  $ip_address = '192.168.0.11'
  $proxy_config = "\
  # Managed By Puppet
  <VirtualHost *:443>
      ServerName splunkproxy.rakops.dev
      SSLEngine on
      SSLProxyVerify none
      ProxyPreserveHost On
      ProxyRequests off
      SSLProxyCheckPeerName off
      SSLProxyCheckPeerCN off
      SSLProxyCheckPeerExpire off
      SSLProxyEngine on
      ProxyPass / https://$ip_address:8000/
      ProxyPassReverse / https://$ip_address:8000/
      SSLCertificateFile      /etc/apache2/ssl/cert.pem
      SSLCertificateKeyFile   /etc/apache2/ssl/key.pem
  </VirtualHost>
  <VirtualHost *:80>
      ServerName nagiosproxy.rakops.dev
      ProxyPreserveHost On
      ProxyRequests off
      ProxyPass / http://$ip_address:8080/nagios
      ProxyPassReverse / http://$ip_address:8080/nagios
  </VirtualHost>
  "

  package { 'apache2':
      ensure => 'latest',
  }

  file { '/etc/apache2/sites-available/reverse-proxy.conf':
      ensure  => 'file',
      content => $proxy_config,
      notify  => Service['apache2'],
  }

  file { '/etc/apache2/ssl':
      ensure  => 'directory',
      require => Package['apache2'],
  }

  file { '/etc/apache2/sites-enabled/reverse-proxy.conf':
      ensure  => 'link',
      target  => '/etc/apache2/sites-available/reverse-proxy.conf',
  }

  service { 'apache2':
      ensure  => 'running',
      enable  => 'true',
      require => Package['apache2'],
  }

  # Install apache2 modules
  exec { '/usr/sbin/a2enmod ssl':
      unless => "/bin/readlink -e /etc/apache2/mods-enabled/ssl.load",
      notify  => Service['apache2'],
  }

  exec { '/usr/sbin/a2enmod proxy':
      unless => "/bin/readlink -e /etc/apache2/mods-enabled/proxy.load",
      notify  => Service['apache2'],
  }
  exec { '/usr/sbin/a2enmod proxy_http':
      unless => "/bin/readlink -e /etc/apache2/mods-enabled/proxy_http.load",
      notify  => Service['apache2'],
  }

  exec { 'generate_ssl_cert':
      command => 'openssl req -x509 -newkey rsa:4096 -keyout /etc/apache2/ssl/key.pem -out /etc/apache2/ssl/cert.pem -days 3650 -nodes -subj "/C=US/ST=MA/L=Boston/O=Company Name/OU=Org/CN=www.example.com"',
      path    => ['/usr/bin', '/usr/sbin',],
      creates => '/etc/apache2/ssl/.key',
      notify  => File['/etc/apache2/sites-available/reverse-proxy.conf'],
  }
}

