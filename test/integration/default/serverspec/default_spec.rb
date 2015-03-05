require 'serverspec'
set :backend, :exec

describe service('flexget') do
  it { should be_running }
end
