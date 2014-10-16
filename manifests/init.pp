class install_mysql (
  $root_password = 'root',
  $innodb_buffer_pool_size = '128M',
  $application_user = 'user',
  $bind_address = '127.0.0.1',
  $application_password = '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19' # password
) {

  class {'::mysql::server':
    root_password => $root_password,
    bind_address => $bind_address,
    override_options => {
      'mysqld' => {'innodb_buffer_pool_size' => $innodb_buffer_pool_size}
    },
    databases => {
      'pulsarplatform_production' => {
        ensure => present,
        charset => 'utf8'
      }
    },
    users => {
      "$application_user@%" => {
        ensure => present,
        password_hash => $application_password
      }
    }
  }

  class {'::mysql::server::backup':
    backupuser => 'backup',
    backuppassword => 'backup',
    backupdir => '/var/backups',
    backuprotate => '5',
    ensure => present
  }

  Class['::mysql::server'] -> Class['::mysql::server::backup']

}