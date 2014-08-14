class install_mysql (
  $root_password = 'root',
  $innodb_buffer_pool_size = '128M'
) {

  class {'::mysql::server':
    root_password => $root_password,
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
      'pulsar@localhost' => {
        ensure => present,
        password_hash => '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19'
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