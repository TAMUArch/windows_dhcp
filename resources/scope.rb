#
# Cookbook:: windows_dhcp
# Resource:: scope
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

unified_mode true

property :scope_name, String, name_property: true
property :startrange, String, regex: Resolv::IPv4::Regex
property :endrange, String, regex: Resolv::IPv4::Regex
property :subnetmask, String, regex: Resolv::IPv4::Regex
property :computername, String
property :description, String
property :version, String, default: '4'
property :scopeid, String, regex: (Resolv::IPv4::Regex || Resolv::IPv6::Regex), required: true

#  Optional params shared
#    AsJob
#    CimSession
#    State: string
#    ThrottleLimit: int32

#  Optional params IPv4
#    ActivatePolicies: Boolean, default true;
#    Delay: int16;
#    LeaseDuration: day.hrs:mins:secs;
#    MaxBootpClients: int32;
#    NapEnable:
#    NapProfile:
#    SuperScoeName: String
#    Type: String

#  Optional params IPv6
#    PassThru
#    Preference: int16
#    PreferenceLifeTime:
#    Prefix: IPAddress
#    T1:
#    T2:
#    ValidLifeTime:

action :create do
  if exists?
    Chef::Log.debug("The scope #{new_resource.scope_name} #{new_resource.scopeid} already exists")
  else
    converge_by("create scope #{new_resource.scope_name}") do
      # Required: Startrange, Endrange, subnetmask, name
      cmd = 'Add-DhcpServerv6Scope' if new_resource.version == '6'
      cmd = 'Add-DhcpServerv4Scope' if new_resource.version == '4'

      cmd << " -StartRange #{new_resource.startrange}"
      cmd << " -EndRange #{new_resource.endrange}"
      cmd << " -Name \"#{new_resource.scope_name}\""
      cmd << " -SubnetMask #{new_resource.subnetmask}"
      # Optional hash needed

      powershell_out!(cmd).run_command
    end
  end
end

action :delete do
  if exists?
    converge_by("delete scope #{new_resource.scope_name}") do
      cmd = 'Remove-DhcpServerv6Scope' if new_resource.version == '6'
      cmd = 'Remove-DhcpServerv4Scope' if new_resource.version == '4'

      cmd << " -scopeid \"#{new_resource.scopeid}\""
      # Optional hash needed

      powershell_out!(cmd).run_command
    end
  else
    Chef::Log.debug("The scope #{new_resource.scope_name} #{new_resource.scopeid} was not found")
  end
end

action_class do
  def exists?
    cmd = 'Get-DhcpServerv6Scope' if new_resource.version == '6'
    cmd = 'Get-DhcpServerv4Scope' if new_resource.version == '4'
    cmd << " -scopeid #{new_resource.scopeid}"
    check = powershell_out(cmd.to_s).run_command
    check.stdout.include?(new_resource.scopeid)
  end
end
