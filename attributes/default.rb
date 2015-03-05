default[:flexget][:version] = nil
default[:flexget][:plugin_dependencies] = []
default[:flexget][:service_enabled] = true
default[:flexget][:service_user] = 'nobody'
default[:flexget][:service_group] = value_for_platform_family(
  %w(debian) => 'nogroup',
  %w(rhel fedora suse) => 'nobody'
)

default[:flexget][:service_env] = {
  'SVWAIT' => '15',
  'PATH' => '$PATH:/usr/local/bin'
}

default[:flexget][:data_dir_path] = '/etc/flexget'
default[:flexget][:log_dir_path] = '/var/log/flexget'
default[:flexget][:config] = {
  :tasks => {
    :test_task => {
      :rss => 'http://mysite.com/myfeed.rss',
      :series => [
        'My Favorite Show',
        'Another Good Show' => { :quality => '720p' }
      ],
      :download => '/tmp'
    }
  }
}
