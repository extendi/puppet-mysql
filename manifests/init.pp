class mysql (
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
    }
  }



}