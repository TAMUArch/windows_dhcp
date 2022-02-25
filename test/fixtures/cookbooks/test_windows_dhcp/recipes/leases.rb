#
# Cookbook:: windows_dhcp
# Recipe:: leases
#
# Copyright:: 2014, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
windows_dhcp_lease 'Workstation3' do
  scopeid '10.0.0.0'
  ipaddress '10.0.0.3'
  computername 'Workstation3'
  macaddress '00:00:00:00:00:11'
  action :create
end

windows_dhcp_lease 'Workstation4' do
  scopeid '10.0.0.0'
  ipaddress '10.0.0.4'
  computername 'Workstation4'
  macaddress '00:00:00:00:00:12'
  action :create
end

windows_dhcp_lease 'Workstation4' do
  scopeid '10.0.0.0'
  ipaddress '10.0.0.4'
  action :delete
end
