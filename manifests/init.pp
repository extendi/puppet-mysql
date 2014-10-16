class install_mysql (
  $root_password = 'root',
  $innodb_buffer_pool_size = '128M',
  $application_user = 'user',
  $bind_address = '127.0.0.1',
  $application_password = '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19' # password
) {

  class {'::mysql::server':
    root_password => $root_password,
    override_options => {
      'mysqld' => {
        'innodb_buffer_pool_size' => $innodb_buffer_pool_size,
        'max_connections' => 800,
        'max_connect_errors' => 10,
        'connect_timeout' => 10,
        'bind_address' => $bind_address,
        }
    },
    databases => {
      'pulsarplatform_production' => {
        ensure => present,
        charset => 'utf8'
      }
    }
    #users => {
    #  "$application_user@localhost" => {
    #    ensure => present,
    #    password_hash => $application_password,
    #    max_connections_per_hour => '0',
    #    max_queries_per_hour     => '0',
    #    max_updates_per_hour     => '0',
    #    max_user_connections     => '0',
    #  }
    #},
    #grants => {
    #  "$application_user@localhost" => {
    #    ensure => 'present',
    #    options => ['GRANT'],
    #    privileges => ['SELECT','INSERT','UPDATE','DELETE','CREATE','CREATE VIEW','SHOW VIEW','DROP','ALTER','INDEX'],
    #    table => 'pulsarplatform_production.*',
    #    user => '$application_user@localhost'
    #  }
    #}
  }

  #mysql_grant {'$application_user@localhost/pulsarplatform_production.*':
  #  ensure     => 'present',
  #  options    => ['GRANT'],
  #  privileges => ['SELECT','INSERT','UPDATE','DELETE','CREATE','CREATE VIEW','SHOW VIEW','DROP','ALTER','INDEX'#],
  #  table      => 'pulsarplatform_production.*',
  #  user       => 'pulsar@localhost'
#
  #}

  class {'::mysql::server::backup':
    backupuser => 'backup',
    backuppassword => 'backup',
    backupdir => '/var/backups',
    backuprotate => '5',
    ensure => present
  }

  Class['::mysql::server'] -> Class['::mysql::server::backup']

}