flexget Cookbook CHANGELOG
=========================
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased
### Changed
- default value of `data_dir_path` attribute changed from "/etc/flexget" to "/opt/flexget"
- expected data structure of `plugin_dependencies` attribute changed from Array to Hash (name => version)
- python modules now install into an isolated virtual environment under `data_dir_path`

## v0.1.0
### Initial release
