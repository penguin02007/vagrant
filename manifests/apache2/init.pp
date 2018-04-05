# Deploy full Splunk instance with reverse proxy
$ip_address = '192.168.0.12'
$insecure_pass = 'passw0rd'
$proxy_config = "\
# Managed By Puppet
<VirtualHost *:443>
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
"

# Enable SSL
$web_config = "\
# Managed By Puppet
[settings]
enableSplunkWebSSL = true
"

package { 'apache2':
    ensure => 'latest',
}

file { '/etc/apache2/sites-available/reverse-proxy.conf':
    ensure  => 'file',
    content => $proxy_config,
    notify  => Service['apache2'],
}

file {'/opt/splunk/etc/system/local/web.conf':
    ensure => 'file',
    content => $web_config,
    notify  => Exec['restart_splunk'],
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

exec { 'reset_splunk_password':
    command => "/opt/splunk/bin/splunk edit user admin -password $insecure_pass -roles admin -auth admin:changeme",
    creates  => '/opt/splunk/etc/.ui_login',
}

exec { 'restart_splunk':
    command => "/opt/splunk/bin/splunk restart",
    refreshonly  => true,
}
