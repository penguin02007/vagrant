$insecure_pass = 'passw0rd'
# Enable SSL
$web_config = "\
# Managed By Puppet
[settings]
enableSplunkWebSSL = true
"

file {'/opt/splunk/etc/system/local/web.conf':
    ensure => 'file',
    content => $web_config,
    notify  => Exec['restart_splunk'],
}

file {'/opt/splunk/etc/system/local/authentication.conf':
    ensure => 'file',
    content => template('splunk/authentication.conf.erb'),
    notify  => Exec['restart_splunk'],
}

exec { 'reset_splunk_password':
    command => "/opt/splunk/bin/splunk edit user admin -password $insecure_pass -roles admin -auth admin:changeme",
    creates  => '/opt/splunk/etc/.ui_login',
}

exec { 'restart_splunk':
    command => "/opt/splunk/bin/splunk restart",
    refreshonly  => true,
}
