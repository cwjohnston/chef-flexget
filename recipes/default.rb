include_recipe 'python'
include_recipe 'runit'

python_pip 'flexget' do
  action :install
  version node[:flexget][:version]
end

node[:flexget][:plugin_dependencies].each do |plugin|
  python_pip plugin do
    action :install
  end
end

config_yml = YAML.dump(node[:flexget][:config].to_hash)

directory node[:flexget][:data_dir_path] do
  owner node[:flexget][:service_user]
  group node[:flexget][:service_group]
  mode '0750'
end

config_path = ::File.join(node[:flexget][:data_dir_path], 'config.yml')

template config_path do
  cookbook node[:flexget][:template_cookbook]
  owner node[:flexget][:service_user]
  group node[:flexget][:service_group]
  source 'config.yml.erb'
  variables(:config => config_yml)
end

directory node[:flexget][:log_dir_path]

runit_service 'flexget' do
  env node[:flexget][:service_env]
  options(
    :service_user => node[:flexget][:service_user],
    :config_path => config_path
  )
  action node[:flexget][:service_enabled] ? :enable : :disable
end
