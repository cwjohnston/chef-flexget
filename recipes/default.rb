include_recipe 'python'
include_recipe 'runit'

directory node[:flexget][:data_dir_path] do
  owner node[:flexget][:service_user]
  group node[:flexget][:service_group]
  mode '0750'
end

env_path = ::File.join(
  node[:flexget][:data_dir_path], 'env'
)

python_virtualenv env_path do
  owner node[:flexget][:service_user]
  group node[:flexget][:service_group]
  action :create
end

modules = {
  'flexget' => node[:flexget][:version]
}.merge(node[:flexget][:plugin_dependencies].to_hash)

modules.each_pair do |m, v|
  python_pip m do
    virtualenv env_path
    version v if v
    action :install
  end
end

config_yml = YAML.dump(node[:flexget][:config].to_hash)
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
    :env_path => env_path,
    :config_path => config_path
  )
  action node[:flexget][:service_enabled] ? :enable : :disable
end
