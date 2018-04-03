$proxy = "<VirtualHost *:8000> 
ProxyPass / https://192.168.0.11:8000/ 
ProxyPassReverse / https://192.168.0.11:8000/ 
</VirtualHost>"

package { 'apache2':
    ensure => 'latest',
}

file { '/etc/apache2/sites-available/reverse-proxy.conf'
    ensure  => 'file',
    content => $proxy,
}

file { '/etc/apache2/sites-enabled/reverse-proxy.conf'
    ensure  => 'link',
    target  => /etc/apache2/sites-available/reverse-proxy.conf,
}

service { 'apache2':
    ensure  => 'running',
    enable  => 'true',
    require => Package['apache2'],
}

exec { 'install_module':
    command => 'a2enmod proxy',
    require => Package['apache2'],
    notify  => Service['apache2'],
}
