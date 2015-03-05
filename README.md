# flexget

This Chef cookbook installs and configures [flexget](http://flexget.com/), a multipurpose automation tool for content retrieval.

## Dependencies

This cookbook depends on the following community cookbooks:

* `python`
* `runit`

## Attributes

* `node[:flexget][:version]` - version of flexget to install, defaults to `nil` which effectively installs the latest available version
* `node[:flexget][:plugin_dependencies]` - an array of python modules which are installed to satisfy flexget plugin dependencies
* `node[:flexget][:service_enabled]` - a boolean which controlls the enabled/disabled state of the flexget runit service
* `node[:flexget][:service_user]` - user to run flexget service under
* `node[:flexget][:service_group]` - group to run flexget service under, `service_user` should probably belong to this group
* `node[:flexget][:service_env]` - a hash of environment variables used to configure the flexget runit service
* `node[:flexget][:data_dir_path]` - path to directory where flexget will store its config file state data (e.g. sqlite database, activity logs)
* `node[:flexget][:log_dir_path]` - path to directory where runit service logs will be written
* `node[:flexget][:config]` - hash representing flexget configuration. This hash is converted to YAML for direct use by flexget.

