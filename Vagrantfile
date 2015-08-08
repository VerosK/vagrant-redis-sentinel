# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  'left' => {
        'ip_addr' => '192.168.11.101',
  },
  'right' => {
        'ip_addr' => '192.168.11.102',
  },
  'center' => {
        'ip_addr' => '192.168.11.103',
  },
}

# write node names to nodes.yaml
require 'yaml'
machines_yaml = File.new('hiera/nodes.yaml','w')
machines_yaml.write({'nodes' => MACHINES}.to_yaml)
machines_yaml.close()

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = 'vStone/centos-7.x-puppet.3.x'
          box.vm.host_name = boxname.to_s

          box.vm.network "private_network", ip: boxconfig['ip_addr']

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "1024"]
          end

          box.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "manifests"
            puppet.manifest_file  = "site.pp"
            puppet.module_path = ['modules']
            puppet.hiera_config_path = 'hiera_config.yaml'
            puppet.options = "--verbose"
          end

#  config.vm.provision :shell, :path => "setup-mirror.sh"

      end
  end
end

